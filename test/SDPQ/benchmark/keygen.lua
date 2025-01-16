
-- how many to test and how much increment
TOTAL = 1000
STEP = 50
TOTAL = TOTAL + STEP -- off by one fix

PQ = require'qp'
ES256 = require'es256'

local KEYGEN_MLDSA44_T = { }
for i=10,TOTAL,STEP do
  local start = os.clock()
  for c=1,i,1 do PQ.mldsa44_keypair() end
  table.insert(KEYGEN_MLDSA44_T, os.clock() - start)
end
collectgarbage'collect'
collectgarbage'collect'


local KEYGEN_ES256_T = { }
for i=10,TOTAL,STEP do
  local start = os.clock()
  for c=1,i,1 do ES256.keygen() end
  table.insert(KEYGEN_ES256_T, os.clock() - start)
end
collectgarbage'collect'
collectgarbage'collect'

print("KEYS \t MLDSA44 \t ES256")
for i=1,(TOTAL/STEP),1 do
  write(i*STEP)
  write(' \t ')
  write(KEYGEN_MLDSA44_T[i])
  write(' \t ')
  write(KEYGEN_ES256_T[i])
  write('\n')
end
