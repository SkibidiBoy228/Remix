import { useEffect, useState } from "react";
import { getContract } from "./contract/contract";
import MediaCard from "./components/MediaCard";

function App() {

  const [media,setMedia] = useState([]);
  const [title,setTitle] = useState("");
  const [url,setUrl] = useState("");

  const loadMedia = async () => {

    const contract = await getContract();

    const data = await contract.getMedia();

    setMedia(data);
  };

  const addMedia = async () => {

    const contract = await getContract();

    const tx = await contract.addMedia(title,url);

    await tx.wait();

    setTitle("");
    setUrl("");
  };

  const deleteMedia = async (id) => {

    const contract = await getContract();

    const tx = await contract.deleteMedia(id);

    await tx.wait();

    loadMedia();
  };

  useEffect(() => {

    loadMedia();

    async function listenEvent(){

      const contract = await getContract();

      contract.on("MediaCreated",(id,title,url)=>{

        setMedia(prev => [
          ...prev,
          {id,title,url,isDeleted:false}
        ]);

      });

    }

    listenEvent();

  },[]);

  return (
    <div style={{padding:"40px"}}>

      <h1>Media DApp</h1>

      <input
        placeholder="Title"
        value={title}
        onChange={e=>setTitle(e.target.value)}
      />

      <input
        placeholder="Image URL"
        value={url}
        onChange={e=>setUrl(e.target.value)}
      />

      <button onClick={addMedia}>
        Add Image
      </button>

      <div style={{
        display:"flex",
        flexWrap:"wrap"
      }}>

        {media.map((m)=>(
          <MediaCard
            key={m.id}
            media={m}
            deleteMedia={deleteMedia}
          />
        ))}

      </div>

    </div>
  );
}

export default App;