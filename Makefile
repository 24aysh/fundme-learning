-include .env
 
build:; forge build
deploy-sepolia:
	forge script script/deployFundme.s.sol:deployFundme --rpc-url $(SEPOLIA_TESTNET) --private-key $(PRIVATE_KEY) --broadcast --verify --etherscan-api-key $(ETHERSCAN_API_KEY) -vvvv