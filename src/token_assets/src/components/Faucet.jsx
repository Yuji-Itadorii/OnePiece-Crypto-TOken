import React , {useState} from "react";
import {token , createActor , canisterId} from "../../../declarations/token"
import { AuthClient } from "../../../../node_modules/@dfinity/auth-client/lib/cjs/index";

function Faucet() {

  const [isDisabled , setisDisabled] = useState(false);
  const [buttonText , setbuttonText] = useState("Gimme Gimme");

  async function handleClick(event) {
    setisDisabled(true);

    // const authClient = await AuthClient.create();
    // const identity = await authClient.getIdentity();

    // const authenticatedCanister = createActor(canisterId , {
    //   agentOptions:{
    //     identity,
    //   },
    // });

    // const result = await authenticatedCanister.payOut();
    const result = await token.payOut();
    setbuttonText(result);
    // setisDisabled(false);
  }

  return (
    <div className="blue window">
      <h2>
        <span role="img" aria-label="tap emoji">
          🚰
        </span>
        Faucet
      </h2>
      <label>Get your free OnePiece tokens here! Claim 10,000 OP tokens to your account.</label>
      <p className="trade-buttons">
        <button id="btn-payout" onClick={handleClick} disabled = {isDisabled}>
          {buttonText}
        </button>
      </p>
    </div>
  );
}

export default Faucet;
