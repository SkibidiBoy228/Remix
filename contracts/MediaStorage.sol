// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract MediaStorage {

    struct Media {
        uint id;
        string title;
        string url;
        bool isDeleted;
    }

    Media[] public mediaList;

    event MediaCreated(
        uint id,
        string title,
        string url
    );

    function addMedia(string memory _title, string memory _url) public {

        uint id = mediaList.length;

        mediaList.push(
            Media(
                id,
                _title,
                _url,
                false
            )
        );

        emit MediaCreated(id, _title, _url);
    }

    function deleteMedia(uint _id) public {
        require(_id < mediaList.length, "Invalid ID");

        mediaList[_id].isDeleted = true;
    }

    function getMedia() public view returns (Media[] memory) {
        return mediaList;
    }
}