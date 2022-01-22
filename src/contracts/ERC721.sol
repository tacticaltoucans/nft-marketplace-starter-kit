// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC721 {
    
    //transfer event

    event Transfer(
        address indexed from, 
        address indexed to, 
        uint256 indexed tokenId);


    //approval event

    event Approval (
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId);


    //function _mint(address to, )

    mapping(uint256 => address) private _tokenOwner;

    mapping(address => uint256) _OwnedTokensCount;

    mapping(uint256 => address) private _tokenApprovals;

    function balanceOf(address _owner) public view returns(uint256) {
        require(_owner !=address(0), 'ERC721: NFT assigned to zero address considered invalid');
        return _OwnedTokensCount[_owner];
    }

    function _exists(uint256 tokenId) internal view returns(bool) {
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }

    function ownerOf(uint256 _tokenId) public view returns(address) {
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0), 'owner query for non-existent token address');
        return owner;
    }

    function _mint(address to, uint256 tokenId) internal virtual {
        require(to != address(0), 'ERC721: minting to the zero address');
        require(!_exists(tokenId), 'ERC721: token already minted');
        _tokenOwner[tokenId] = to;
        _OwnedTokensCount[to] +=  1;

        emit Transfer(address(0), to, tokenId);
    }
    
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'ERC721: transfer to the zero address');
        require(ownerOf(_tokenId) == _from, 'address does not own this token');
        _OwnedTokensCount[_from] -= 1;
        _OwnedTokensCount[_to] += 1;
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        _transferFrom(_from, _to, _tokenId);
    }

    //require that the person approving is the owner
    //approve an address to a token
    //require that we can't approve sending tokens to the owner of the owner
    //update the map of the approval addresses

    function approve(address _to, uint256 tokenId) public{
        address owner = ownerOf(tokenId);
        require(_to != owner, 'Error - approval to current owner');
        require(msg.sender == owner, 'Error - current caller is not the owner');
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }
}



