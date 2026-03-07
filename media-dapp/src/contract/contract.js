import { ethers } from "ethers";

export const contractAddress = "0xd9145CCE52D386f254917e481eB44e9943F39138";

export const abi = [
  "function addMedia(string _title,string _url)",
  "function deleteMedia(uint _id)",
  "function getMedia() view returns(tuple(uint id,string title,string url,bool isDeleted)[])",
  "event MediaCreated(uint id,string title,string url)"
];

export const getContract = async () => {

  const provider = new ethers.BrowserProvider(window.ethereum);

  const signer = await provider.getSigner();

  return new ethers.Contract(contractAddress, abi, signer);
};