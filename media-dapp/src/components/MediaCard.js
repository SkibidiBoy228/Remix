const MediaCard = ({ media, deleteMedia }) => {

  if (media.isDeleted) return null;

  return (
    <div style={{
      border:"1px solid gray",
      padding:"10px",
      margin:"10px",
      width:"250px"
    }}>

      <img
        src={media.url}
        alt={media.title}
        width="200"
      />

      <h3>{media.title}</h3>

      <button onClick={() => deleteMedia(media.id)}>
        Delete
      </button>

    </div>
  );
};

export default MediaCard;