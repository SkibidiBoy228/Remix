let web3;
let contract;
let account;

const contractAddress = "0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8";

const abi = [
  {
    "inputs":[{"internalType":"string","name":"_question","type":"string"},{"internalType":"string[]","name":"_options","type":"string[]"}],
    "name":"createPoll",
    "outputs":[],
    "stateMutability":"nonpayable",
    "type":"function"
  },
  {
    "inputs":[{"internalType":"uint256","name":"_pollId","type":"uint256"},{"internalType":"uint256","name":"_optionIndex","type":"uint256"}],
    "name":"vote",
    "outputs":[],
    "stateMutability":"nonpayable",
    "type":"function"
  },
  {
    "inputs":[{"internalType":"uint256","name":"_pollId","type":"uint256"}],
    "name":"getVotes",
    "outputs":[{"internalType":"uint256[]","name":"","type":"uint256[]"}],
    "stateMutability":"view",
    "type":"function"
  },
  {
    "inputs":[{"internalType":"uint256","name":"_pollId","type":"uint256"}],
    "name":"getOptions",
    "outputs":[{"internalType":"string[]","name":"","type":"string[]"}],
    "stateMutability":"view",
    "type":"function"
  },
  {
    "inputs":[{"internalType":"uint256","name":"_pollId","type":"uint256"}],
    "name":"getQuestion",
    "outputs":[{"internalType":"string","name":"","type":"string"}],
    "stateMutability":"view",
    "type":"function"
  },
  {
    "inputs":[],
    "name":"pollCount",
    "outputs":[{"internalType":"uint256","name":"","type":"uint256"}],
    "stateMutability":"view",
    "type":"function"
  }
];

async function connectWallet() {
    web3 = new Web3(window.ethereum);
    await window.ethereum.request({ method: "eth_requestAccounts" });

    const accounts = await web3.eth.getAccounts();
    account = accounts[0];

    document.getElementById("account").innerText = account;

    contract = new web3.eth.Contract(abi, contractAddress);
}

async function createPoll() {
    const question = document.getElementById("question").value;
    const options = document.getElementById("options").value.split(",");

    await contract.methods.createPoll(question, options)
        .send({ from: account });

    alert("Poll created");
}

async function vote() {
    const pollId = document.getElementById("votePollId").value;
    const option = document.getElementById("voteOption").value;

    await contract.methods.vote(pollId, option)
        .send({ from: account });

    alert("Vote submitted");
}

async function getResults() {
    const pollId = document.getElementById("resultPollId").value;

    const question = await contract.methods.getQuestion(pollId).call();
    const options = await contract.methods.getOptions(pollId).call();
    const votes = await contract.methods.getVotes(pollId).call();

    document.getElementById("questionText").innerText = question;

    let resultText = "";

    for (let i = 0; i < options.length; i++) {
        resultText += options[i] + " : " + votes[i] + " votes\n";
    }

    document.getElementById("results").innerText = resultText;
}

