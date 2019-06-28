import React, { Component } from "react";
import OluwafemiShobandeToken from "./contracts/OluwafemiShobandeToken.json";
import getWeb3 from "./utils/getWeb3";

import "./App.css";

class App extends Component {
  state = { name: null, symbol: null, decimals: null, web3: null, accounts: null, contract: null, amount: 0 };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();
      
      const instance = new web3.eth.Contract(
        OluwafemiShobandeToken.abi, "0x28bea2bc0eEf8924CF72dfDd90E3048b31aeA308"
        // deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };

  runExample = async () => {
    const { contract } = this.state;

    // Stores a given value, 5 by default.
    // await contract.methods.set(5).send({ from: accounts[0] });

    // Get token name
    const name = await contract.methods.name().call();

    //Get token symbol
    const symbol = await contract.methods.symbol().call();

    //Get token decimals
    const decimals = await contract.methods.decimals().call();

    // Update state with the result.
    this.setState({ name, symbol, decimals });
  };

  handleChange = (event) => {
    const { name, value } = event.target;
    this.setState({
      [name]: value
    })
  }

  mint = async (event) => {
    event.preventDefault();
    try {
      await this.state.contract.methods.mint(this.state.amount).send({ from: this.state.accounts[0] });
    } catch (error) {
      alert("Failed to mint new tokens. Check console for details");
      console.log(error);
    }
  }

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>{this.state.name} - {this.state.symbol}</h1>
        <h2>Let's get Minting</h2>
        
        <form action="">
          <input type="number" name="amount"  value={this.state.amount} onChange={this.handleChange} />
          <input onClick={this.mint} type="submit" value="Submit" />
        </form>

        <p>Decimals: {this.state.decimals}</p>
      </div>
    );
  }
}

export default App;
