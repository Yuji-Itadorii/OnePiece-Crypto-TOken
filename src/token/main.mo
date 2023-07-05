import Principal "mo:base/Principal";
import Nat "mo:base/Nat";
import Text "mo:base/Text";
import HashMap "mo:base/HashMap";
import Debug "mo:base/Debug";
import Iter "mo:base/Iter";

actor Token{
  let owner : Principal = Principal.fromText("dqbw6-ds7xm-gyi4z-rvoy4-4452j-o3x5z-dasio-gc3kq-yboec-j42vs-cae");
  let totalSupply : Nat = 1000000000;
  let symbol : Text = "OP";

  private stable var balanceEntries : [(Principal , Nat)] = [];
  private var balances = HashMap.HashMap<Principal , Nat>(1 , Principal.equal , Principal.hash);
  if(balances.size() < 1){
      balances.put(owner , totalSupply);
    };
  

  public query func balanceOf(who : Principal) : async Nat {

    let balance : Nat = switch (balances.get(who)){
      case null 0;
      case (?result) result;
    };

    return balance;
  };

  public query func getSymbol() : async Text{
    return symbol;
  };

  public shared(msg) func payOut() : async Text{

    Debug.print(debug_show (msg.caller));

    if(balances.get(msg.caller) == null){
      let result = await transfer(msg.caller , 10000);
      return result;
    }
    else{
      return "This Account already collected entry points.";
    };

  };

  public shared(msg) func transfer(to : Principal , amount : Nat) : async Text{
    let fromBalance  = await balanceOf(msg.caller);
    if(fromBalance >= amount){
      
      let newFromBalance : Nat  = fromBalance - amount;
      balances.put(msg.caller , newFromBalance);
      
      let toBalance = await balanceOf(to);
      let newTOBalance = toBalance + amount;
      balances.put(to , newTOBalance);
      
      return "Success";
    }
    else{
      return "Insufficient Token";
    };
  };

  system func preupgrade(){
    balanceEntries := Iter.toArray(balances.entries());
  };

  system func postupgrade(){
    balances := HashMap.fromIter<Principal , Nat>(balanceEntries.vals() , 1 , Principal.equal , Principal.hash);

    if(balances.size() < 1){
      balances.put(owner , totalSupply);
    }
  };

}