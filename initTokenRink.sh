# this testing strategy is from: https://blog.zeppelinos.org/testing-real-world-contract-upgrades/

# first start a session to make sure all following commands go to rinkeby: npx zos session --network rinkeby --from $SOME_ADDRESS_YOU_CONTROL

# then, run `npx zos push` to deploy the current logic contract

# then execute this script (change the testDevFundAddress if you want) to create the corresponding proxy

testName='RelevantToken'
testDecimals=18
testSymbol='RVT'
testVersion='v1'
testDevFundAddress='0x118e26f0245dCC9FCFA98d7939d0825B7D041EBa'
initRoundReward=25000
initRoundRewardBNString=$(echo "$initRoundReward*10^18" | bc)
timeConstantBNString=12638008558187319448473
targetInflation=10880216701148
targetRound=26704
roundLength=1
roundDecayBNString=999920876739935000
totalPremintBNString=277770446297438000000000000

args=$(echo $testName,$testDecimals,$testSymbol,$testVersion,$testDevFundAddress,$initRoundRewardBNString,$timeConstantBNString,$targetInflation,$targetRound,$roundLength,$roundDecayBNString,$totalPremintBNString)
echo $args
npx zos create RelevantToken --init initialize --args $args


# to test upgrading, run a forked rinkeby network from a separate terminal window:
# ganache-cli --fork https://rinkeby.infura.io/v3/<INFURA_API_KEY> --unlock "$SOME_ADDRESS_YOU_CONTROL" --port 9545 --networkId 1004 --deterministic

# we need to trick ZeppelinOS into thinking that this test network has the same state as the real Rinkeby. To do this, we just need to:
# cp zos.rinkeby.json zos.dev-1004.json

# if you want to verify that your chain is actually forked with the current state, you can run `truffle console --network rinkeby-test`
# and interact with the main proxy contract using the same address returned after the `npx zos create` command from above

# now it's time to make your contract changes, push them to this forked chain and test them before going public:

# first start a new session to connect to the forked network: `npx zos session --network rinkeby-test --from $SOME_ADDRESS_YOU_CONTROL`
# make the desired contract changes and run `npx zos push`

# Lastly connect the newly deployed logic contract with the existing proxy: by running `npx zos update RelevantToken`
# You can add the iniitializer function for the newly added variables as a parameter to the zos update command:

# airdropSwitchRound=8352
# airdropRoundDecay=999762649000782000
# firstNewAirdrop=3442799625893100000000
# upgradeInitArgs=$(echo $airdropSwitchRound,$airdropRoundDecay,$firstNewAirdrop)
# echo $upgradeInitArgs
# npx zos update RelevantToken --init initializeRewardSplit --args $upgradeInitArgs

# OR you can just do `npx zos update` and initialize the new contract manually with truffle console:
# contract.initializeRewardSplit(8352,"999762649000782000","3442799625893100000000")

# Now test the new proxy using `truffle console --network rinkeby-test`
# If all upgrades appear to have worked, push and update on the actual rinkeby

# Be happy!