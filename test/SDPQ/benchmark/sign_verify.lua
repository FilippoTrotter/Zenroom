local SD = require'crypto_sd_jwt'
local ES256 = require'es256'
local PQ = require'qp'
-- how many to test and how much increment
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
        if i % 5 == 0 then
            -- Add an array field
            test_sdr.object[key] = {O.random(512), O.random(512)}
        else
            -- Add a string field
            test_sdr.object[key] = O.random(512)
        end
        table.insert(fields, O.from_string(key))
    end

   test_sdr.fields = fields
    return test_sdr
end

local SIGN_ES256_T = { }
local SIGN_PQ_T = {}
local VERIFY_ES256_T = { }
local VERIFY_PQ_T = {}

local sk = ES256.keygen()
local pk = ES256.pubgen(sk)
for i=STEP,TOTAL,STEP do

    local test_sdr = generate_random_payload(sdr, i)
    local test_jwt = SD.create_sd(test_sdr)
    collectgarbage'collect'
    collectgarbage'collect'

    local start = os.clock()
    local sd_jwt = SD.create_jwt_es256(test_jwt.payload, sk)
    table.insert(SIGN_ES256_T, os.clock() - start)

    local start = os.clock()
    assert( SD.verify_jws_signature(sd_jwt, pk))
    table.insert(VERIFY_ES256_T, os.clock() - start)

end
collectgarbage'collect'
collectgarbage'collect'
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

print("DISC \t SIGN_PQ \t SIGN_ES256 \t VERIFY_PQ \t VERIFY_ES256")
for i=1,(TOTAL/STEP),1 do
    write(i*STEP)
    write(' \t ')
    write(SIGN_PQ_T[i])
    write(' \t ')
    write(SIGN_ES256_T[i])
    write(' \t ')
    write(VERIFY_PQ_T[i])
    write(' \t ')
    write(VERIFY_ES256_T[i])
    write('\n')
end
