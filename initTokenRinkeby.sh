# this testing strategy is from: https://blog.zeppelinos.org/testing-real-world-contract-upgrades/

# first, run `npx zos push --network rinkeby` to deploy the current logic contract
# then execute this script (change the testDevFundAddress if you want) to create the corresponding proxy

testName='RelevantToken'
testDecimals=18
testSymbol='RVT'
testVersion='v1'
testDevFundAddress='0xffcf8fdee72ac11b5c542428b35eef5769c409f0'
initRoundReward=25000
initRoundRewardBNString=$(echo "$initRoundReward*10^18" | bc)
timeConstant=$(echo "8760*10^18/l(2)" | bc -l)
timeConstantBNString=$(printf "%.0f\n" $timeConstant)
targetInflation=10880216701148
targetRound=26704
roundLength=1
roundDecayBNString=999920876739935000
totalPremintBNString=277770446297438000000000000

args=$(echo $testName,$testDecimals,$testSymbol,$testVersion,$testDevFundAddress,$initRoundRewardBNString,$timeConstantBNString,$targetInflation,$targetRound,$roundLength,$roundDecayBNString,$totalPremintBNString)
echo $args
npx zos create RelevantToken --init initialize --args $args --network rinkeby

# to test upgrading, run a forked rinkeby network from a separate terminal window:
# ganache-cli --fork rinkeby.infura.io/v3/<INFURA_API_KEY> --unlock "$SOME_ADDRESS_YOU_CONTROL" --port 9545 --networkId 1004 --deterministic

# we need to trick ZeppelinOS into thinking that this test network has the same state as the real Rinkeby. To do this, we just need to:
# cp zos.rinkeby.json zos.dev-1004.json

# now you can run `truffle console --network rinkeby-test` and interact with the main proxy contract on your own forked chain

# it't time to make your contract changes, push them to this forked chain and test them before going public:
# first start a new session to connect to the forked network: `npx zos session --network rinkeby-test --from $SOME_ADDRESS_YOU_CONTROL`
# make the desired contract changes and run `npx zos push --network rinkeby-test`



`
