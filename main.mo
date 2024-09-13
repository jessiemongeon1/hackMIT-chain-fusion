import EvmRpc "canister:evm_rpc";
import ic "ic:aaaaa-aa";
import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";

actor {
    let BITCOIN_FEE = 2016000000;
    public func getLogs() : async ?[EvmRpc.LogEntry] {

        // Configure RPC request
        let services : EvmRpc.RpcServices = #EthMainnet(?[#PublicNode]);
        let config = null;

        // Add cycles to next call
        Cycles.add<system>(10000000000);

        // Call an RPC method
        let result = await EvmRpc.eth_getLogs(
            services,
            config,
            {
                addresses = ["0xB9B002e70AdF0F544Cd0F6b80BF12d4925B0695F"];
                fromBlock = ?#Number 19520540;
                toBlock = ?#Number 19520940;
                topics = ?[
                    ["0x4d69d0bd4287b7f66c548f90154dc81bc98f65a1b362775df5ae171a2ccd262b"],
                    [
                        "0x000000000000000000000000352413d00d2963dfc58bc2d6c57caca1e714d428",
                        "0x000000000000000000000000b6bc16189ec3d33041c893b44511c594b1736b8a",
                    ],
                ];
            },
        );

        // Process results
        switch result {
          // Consistent, successful results
          case (#Consistent(#Ok value)) {
            await send_bitcoin();
            ?value
          };
          // Consistent error message
          case (#Consistent(#Err error)) {
            Debug.trap("Error: " # debug_show error);
            null
          };
          // Inconsistent results between RPC providers
          case (#Inconsistent(results)) {
            Debug.trap("Inconsistent results: " # debug_show results);
            null
          };
        };
    };
        // Function that sends bitcoin. This is used by check_evm_log()
    public func send_bitcoin() : async () {
        Cycles.add<system>(BITCOIN_FEE);
        await ic.bitcoin_send_transaction({
        transaction = "\be\ef";
        network = #testnet;
        });
    };

};

