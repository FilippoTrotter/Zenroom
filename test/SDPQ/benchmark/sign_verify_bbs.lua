local SD = require'crypto_sd_jwt'
local PQ = require'qp'
local BBS = require'crypto_bbs'

TOTAL = 1000
STEP = 50
TOTAL = TOTAL + STEP -- off by one fixed
local sdr = {
    object = {
        iss = O.from_string("https://pid-provider.memberstate.example.eu"),
        iat = 1541493724,
        type = O.from_string("TestExample"),
        exp = 1883000000,
    }
}

local function generate_random_payload(sdr, num_fields)
    local test_sdr = deepcopy(sdr)

    local fields = {}
    for i = 1, num_fields do
        local key = "field_" .. i
        test_sdr.object[key] = O.random(512)
        table.insert(fields, O.from_string(key))
    end

   test_sdr.fields = fields
    return test_sdr
end

local SIGN_BBS_T = { }
local SIGN_PQ_T = {}
local VERIFY_BBS_T = { }
local VERIFY_PQ_T = {}

local keys = PQ.mldsa44_keypair()
for i=STEP,TOTAL,STEP do

    local test_sdr_pq = generate_random_payload(sdr, i)
    local test_jwt_pq = SD.create_sd(test_sdr_pq)
    collectgarbage'collect'
    collectgarbage'collect'

    local start = os.clock()
    local sd_jwt = SD.create_jwt_pq(test_jwt_pq.payload, keys.private)
    table.insert(SIGN_PQ_T, os.clock() - start)

    local start = os.clock()
    assert( SD.verify_jws_pq_signature(sd_jwt, keys.public))
    table.insert(VERIFY_PQ_T, os.clock() - start)

end
collectgarbage'collect'
collectgarbage'collect'
B3 = BBS.ciphersuite'shake256'

for i=STEP,TOTAL,STEP do
    local sk= BBS.keygen(B3)
    local pk = BBS.sk2pk(sk)
    local messages = { }
    for c=1,i,1 do
        table.insert(messages, O.random(512))
    end
    collectgarbage'collect'
    collectgarbage'collect'
    local start = os.clock()
    local signed = BBS.sign(B3, sk, pk, nil, messages)
    table.insert(SIGN_BBS_T, os.clock() - start)
    local start = os.clock()
    assert( BBS.verify(B3, pk, signed, nil, messages) )
    table.insert(VERIFY_BBS_T, os.clock() - start)
  end
  collectgarbage'collect'
  collectgarbage'collect'

print("DISC \t SIGN_PQ \t SIGN_BBS \t VERIFY_PQ \t VERIFY_BBS")
for i=1,(TOTAL/STEP),1 do
    write(i*STEP)
    write(' \t ')
    write(SIGN_PQ_T[i])
    write(' \t ')
    write(SIGN_BBS_T[i])
    write(' \t ')
    write(VERIFY_PQ_T[i])
    write(' \t ')
    write(VERIFY_BBS_T[i])
    write('\n')
end
