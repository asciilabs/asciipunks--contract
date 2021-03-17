// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract AsciiPunks {
    using Address for address;

    // EVENTS
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    event Generated(uint256 indexed index, address indexed a, string value);

    mapping(bytes4 => bool) private _supportedInterfaces;
    mapping(uint256 => uint256) internal idToSeed;
    mapping(uint256 => uint256) internal seedToId;
    mapping(uint256 => address) internal idToOwner;
    mapping(address => uint256[]) internal ownerToIds;
    mapping(uint256 => uint256) internal idToOwnerIndex;
    mapping(address => mapping(address => bool)) internal ownerToOperators;
    mapping(uint256 => address) internal idToApproval;

    uint256 internal numTokens = 0;
    uint256 public constant TOKEN_LIMIT = 512;
    uint256 public constant PRICE = 300000000000000000;

    string internal _NFTName = "AsciiPunks";
    string internal _NFTSymbol = "ASC";

    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    modifier validNFToken(uint256 _tokenId) {
        require(
            idToOwner[_tokenId] != address(0),
            "ERC721: query for nonexistent token"
        );
        _;
    }

    modifier canOperate(uint256 _tokenId) {
        address owner = idToOwner[_tokenId];

        require(
            owner == msg.sender || ownerToOperators[owner][msg.sender],
            "ERC721: approve caller is not owner nor approved for all"
        );
        _;
    }

    modifier canTransfer(uint256 _tokenId) {
        address tokenOwner = idToOwner[_tokenId];

        require(
            tokenOwner == msg.sender ||
                idToApproval[_tokenId] == msg.sender ||
                ownerToOperators[tokenOwner][msg.sender],
            "ERC721: transfer caller is not owner nor approved"
        );
        _;
    }

    constructor() {
        _registerInterface(_INTERFACE_ID_ERC165);
        _registerInterface(_INTERFACE_ID_ERC721);
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

    // MINTING
    function createPunk(uint256 seed) external payable returns (string memory) {
        return _mint(msg.sender, seed);
    }

    function _mint(address _to, uint256 seed) internal returns (string memory) {
        require(_to != address(0), "ERC721: mint to the zero address");
        require(
            numTokens < TOKEN_LIMIT,
            "ERC721: maximum number of tokens already minted"
        );
        require(msg.value >= PRICE, "ERC721: insufficient ether");
        require(seedToId[seed] == 0, "ERC721: seed already used");

        uint256 id = numTokens + 1;

        idToSeed[id] = seed;
        seedToId[seed] = id;

        string memory uri = _draw(id);
        emit Generated(id, _to, uri);

        numTokens = numTokens + 1;
        _registerToken(_to, id);

        emit Transfer(address(0), _to, id);

        return uri;
    }

    function _registerToken(address _to, uint256 _tokenId) internal {
        require(idToOwner[_tokenId] == address(0));
        idToOwner[_tokenId] = _to;

        ownerToIds[_to].push(_tokenId);
        uint256 length = ownerToIds[_to].length;
        idToOwnerIndex[_tokenId] = length - 1;
    }

    // DRAWING
    function _draw(uint256 id) internal view returns (string memory) {
        uint256 rand = uint256(keccak256(abi.encodePacked(idToSeed[id])));
        // rand % 1000 // for 0 to 999 inclusive

        string memory hat =
            unicode"            \n"
            unicode"            \n"
            unicode"   ┌────┐   \n";

        string memory eyes = _drawEyes(rand);
        string memory moustache = unicode"   │    │   \n";

        string memory mouth = unicode"   │──  │   \n";

        string memory chin = unicode"   │    │   \n" unicode"   └──┘ │   \n";
        string memory neck = unicode"     │  │   \n" unicode"     │  │   \n";

        return
            string(abi.encodePacked(hat, eyes, moustache, mouth, chin, neck));
    }

    function _drawEyes(uint256 rand) internal view returns (string memory) {
        string[48] memory leftEyes =
            [
                unicode"◕",
                unicode"ಥ",
                unicode"♥"
                unicode"ʘ̚",
                unicode"X",
                unicode"⊙",
                unicode"˘",
                unicode"ಠ",
                unicode"◉",
                unicode"⚆",
                unicode"¬",
                unicode"^",
                unicode"═",
                unicode"┼",
                unicode"┬",
                unicode"■",
                unicode"─",
                unicode"û",
                unicode"╜",
                unicode"δ",
                unicode"│",
                unicode"┐",
                unicode"┌",
                unicode"┌",
                unicode"╤",
                unicode"/",
                unicode"\\",
                unicode"/",
                unicode"\\",
                unicode"╦",
                unicode"♥",
                unicode"♠",
                unicode"♦",
                unicode"╝",
                unicode"◄",
                unicode"►",
                unicode"◄",
                unicode"►",
                unicode"I",
                unicode"╚",
                unicode"╔",
                unicode"╙",
                unicode"╜",
                unicode"╓",
                unicode"╥",
                unicode"$",
                unicode"○",
                unicode"N",
                unicode"x"
            ];

        string[48] memory rightEyes =
            [
                unicode"◕",
                unicode"ಥ",
                unicode"♥",
                unicode"ʘ̚",
                unicode"X",
                unicode"⊙",
                unicode"˘",
                unicode"ಠ",
                unicode"◉",
                unicode"⚆",
                unicode"¬",
                unicode"^"
                unicode"═",
                unicode"┼",
                unicode"┬",
                unicode"■",
                unicode"─",
                unicode"û",
                unicode"╜",
                unicode"δ",
                unicode"│",
                unicode"┐",
                unicode"┐",
                unicode"┌",
                unicode"╤",
                unicode"\\",
                unicode"/",
                unicode"/",
                unicode"\\",
                unicode"╦",
                unicode"♠",
                unicode"♣",
                unicode"♦",
                unicode"╝",
                unicode"►",
                unicode"◄",
                unicode"◄",
                unicode"◄",
                unicode"I",
                unicode"╚",
                unicode"╗",
                unicode"╜",
                unicode"╜",
                unicode"╓",
                unicode"╥",
                unicode"$",
                unicode"○",
                unicode"N",
                unicode"x"
            ];
        uint256 eyeId = rand % 48;

        string memory leftEye = leftEyes[eyeId];
        string memory rightEye = rightEyes[eyeId];
        string memory nose = _drawNose(rand);

        string memory forehead = unicode"   │    ├┐  \n";
        string memory leftFace = unicode"   │";
        string memory rightFace = unicode" └│  \n";

        return
            string(
                abi.encodePacked(
                    forehead,
                    leftFace,
                    leftEye,
                    " ",
                    rightEye,
                    rightFace,
                    nose
                )
            );
    }

    function _drawNose(uint256 rand) internal view returns (string memory) {
        string[9] memory noses =
            [
                unicode"└",
                unicode"╘",
                unicode"<",
                unicode"└",
                unicode"┌",
                unicode"^",
                unicode"└",
                unicode"┼",
                unicode"Γ"
            ];

        uint256 noseId = rand % 9;
        string memory nose = noses[noseId];
        return
            string(abi.encodePacked(unicode"   │ ", nose, unicode"  └┘  \n"));
    }

    function name() external view returns (string memory) {
        return _NFTName;
    }

    function symbol() external view returns (string memory) {
        return _NFTSymbol;
    }

    function tokenURI(uint256 _tokenId)
        external
        view
        validNFToken(_tokenId)
        returns (string memory)
    {
        return _draw(_tokenId);
    }

    function totalSupply() public view returns (uint256) {
        return numTokens;
    }

    function tokenByIndex(uint256 index) public view returns (uint256) {
        require(
            index < numTokens,
            "ERC721Enumerable: global index out of bounds"
        );
        return index;
    }

    function tokenOfOwnerByIndex(address _owner, uint256 _index)
        external
        view
        returns (uint256)
    {
        require(
            _index < ownerToIds[_owner].length,
            "ERC721Enumerable: owner index out of bounds"
        );
        return ownerToIds[_owner][_index];
    }

    function balanceOf(address _owner) external view returns (uint256) {
        require(
            _owner != address(0),
            "ERC721: balance query for the zero address"
        );
        return ownerToIds[_owner].length;
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return _ownerOf(_tokenId);
    }

    function _ownerOf(uint256 _tokenId)
        internal
        view
        validNFToken(_tokenId)
        returns (address)
    {
        address _owner = idToOwner[_tokenId];
        require(_owner != address(0), "ERC721: query for nonexistent token");
        return _owner;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external validNFToken(_tokenId) canTransfer(_tokenId) {
        address tokenOwner = idToOwner[_tokenId];
        require(
            tokenOwner == _from,
            "ERC721: transfer of token that is not own"
        );
        require(_to != address(0), "ERC721: transfer to the zero address");
        _transfer(_to, _tokenId);
    }

    function _transfer(address _to, uint256 _tokenId) internal {
        address from = idToOwner[_tokenId];
        _clearApproval(_tokenId);
        emit Approval(from, _to, _tokenId);

        _removeNFToken(from, _tokenId);
        _registerToken(_to, _tokenId);

        emit Transfer(from, _to, _tokenId);
    }

    function _removeNFToken(address _from, uint256 _tokenId) internal {
        require(idToOwner[_tokenId] == _from);
        delete idToOwner[_tokenId];

        uint256 tokenToRemoveIndex = idToOwnerIndex[_tokenId];
        uint256 lastTokenIndex = ownerToIds[_from].length - 1;

        if (lastTokenIndex != tokenToRemoveIndex) {
            uint256 lastToken = ownerToIds[_from][lastTokenIndex];
            ownerToIds[_from][tokenToRemoveIndex] = lastToken;
            idToOwnerIndex[lastToken] = tokenToRemoveIndex;
        }

        ownerToIds[_from].pop();
    }

    function approve(address _approved, uint256 _tokenId)
        external
        validNFToken(_tokenId)
        canOperate(_tokenId)
    {
        address owner = idToOwner[_tokenId];
        require(_approved != owner, "ERC721: approval to current owner");
        idToApproval[_tokenId] = _approved;
        emit Approval(owner, _approved, _tokenId);
    }

    function _clearApproval(uint256 _tokenId) private {
        if (idToApproval[_tokenId] != address(0)) {
            delete idToApproval[_tokenId];
        }
    }

    function getApproved(uint256 _tokenId)
        external
        view
        validNFToken(_tokenId)
        returns (address)
    {
        return idToApproval[_tokenId];
    }

    function setApprovalForAll(address _operator, bool _approved) external {
        require(_operator != msg.sender, "ERC721: approve to caller");
        ownerToOperators[msg.sender][_operator] = _approved;
        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function isApprovedForAll(address _owner, address _operator)
        external
        view
        returns (bool)
    {
        return ownerToOperators[_owner][_operator];
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes calldata _data
    ) external {
        _safeTransferFrom(_from, _to, _tokenId, _data);
    }

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external {
        _safeTransferFrom(_from, _to, _tokenId, "");
    }

    function _safeTransferFrom(
        address _from,
        address _to,
        uint256 _tokenId,
        bytes memory _data
    ) private validNFToken(_tokenId) canTransfer(_tokenId) {
        address tokenOwner = idToOwner[_tokenId];
        require(
            tokenOwner == _from,
            "ERC721: transfer of token that is not own"
        );
        require(_to != address(0), "ERC721: transfer to the zero address");

        _transfer(_to, _tokenId);
        require(
            _checkOnERC721Received(_from, _to, _tokenId, _data),
            "ERC721: transfer to non ERC721Receiver implementer"
        );
    }

    function _checkOnERC721Received(
        address from,
        address to,
        uint256 tokenId,
        bytes memory _data
    ) private returns (bool) {
        if (to.isContract()) {
            try
                IERC721Receiver(to).onERC721Received(
                    msg.sender,
                    from,
                    tokenId,
                    _data
                )
            returns (bytes4 retval) {
                return retval == IERC721Receiver(to).onERC721Received.selector;
            } catch (bytes memory reason) {
                if (reason.length == 0) {
                    revert(
                        "ERC721: transfer to non ERC721Receiver implementer"
                    );
                } else {
                    assembly {
                        revert(add(32, reason), mload(reason))
                    }
                }
            }
        } else {
            return true;
        }
    }

    function supportsInterface(bytes4 _interfaceID)
        external
        view
        returns (bool)
    {
        return _supportedInterfaces[_interfaceID];
    }

    function _registerInterface(bytes4 interfaceId) internal {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}
