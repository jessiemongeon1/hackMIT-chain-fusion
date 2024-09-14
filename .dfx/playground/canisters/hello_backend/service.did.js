export const idlFactory = ({ IDL }) => {
  const LogEntry = IDL.Record({
    'transactionHash' : IDL.Opt(IDL.Text),
    'blockNumber' : IDL.Opt(IDL.Nat),
    'data' : IDL.Text,
    'blockHash' : IDL.Opt(IDL.Text),
    'transactionIndex' : IDL.Opt(IDL.Nat),
    'topics' : IDL.Vec(IDL.Text),
    'address' : IDL.Text,
    'logIndex' : IDL.Opt(IDL.Nat),
    'removed' : IDL.Bool,
  });
  return IDL.Service({
    'getLogs' : IDL.Func([], [IDL.Opt(IDL.Vec(LogEntry))], []),
    'send_bitcoin' : IDL.Func([], [], []),
  });
};
export const init = ({ IDL }) => { return []; };
