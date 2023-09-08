-include .env #instead of manually type source .env

format:
	forge fmt

install-foundry: #to test
	curl -L https://foundry.paradigm.xyz | bash
	source /Users/stefaniapozzi/.bashrc
	foundryup

init:
	forge init
	forge compile

install-packages:
	forge install cyfrin/foundry-devops@0.0.11 --no-commit && forge install smartcontractkit/chainlink-brownie-contracts@0.6.1 --no-commit && forge install foundry-rs/forge-std@v1.5.3 --no-commit

build:; forge build

deploy-anvil:
	forge script script/FundmeDeploy.s.sol --rpc-url http://localhost:8545 --private-key $(ANVIL_PRIVATE_KEY) --broadcast

deploy-sepolia:
	forge script script/FundmeDeploy.s.sol --rpc-url $(SEPOLIA_ALCHEMY_RPC_URL) --private-key $(METAMASK_PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv

interaction:
	forge script script/Interactions.s.sol:FundInteraction --rpc-url $(SEPOLIA_ALCHEMY_RPC_URL)  --private-key $(METAMASK_PRIVATE_KEY)  --broadcast