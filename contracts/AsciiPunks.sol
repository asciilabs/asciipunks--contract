pragma solidity ^0.8.0;

contract AsciiPunks {
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    /**
     * @dev Emitted when new punk is minted.
     */
    event Generated(uint256 indexed index, address indexed a, string value);

    /**
     * @dev Mapping of interface ids to whether or not it's supported.
     */
    mapping(bytes4 => bool) private _supportedInterfaces;

    /**
     * @dev A mapping from NFT ID to the seed used to make it.
     */
    mapping(uint256 => uint256) internal idToSeed;
    mapping(uint256 => uint256) internal seedToId;

    /**
     * @dev A mapping from NFT ID to the address that owns it.
     */
    mapping(uint256 => address) internal idToOwner;

    /**
     * @dev Mapping from owner to list of owned NFT IDs.
     */
    mapping(address => uint256[]) internal ownerToIds;

    /**
     * @dev Mapping from NFT ID to its index in the owner tokens list.
     */
    mapping(uint256 => uint256) internal idToOwnerIndex;

    /**
     * @dev Total number of tokens.
     */
    uint256 internal numTokens = 0;

    /**
     * @dev Guarantees that _tokenId is a valid Token.
     * @param _tokenId ID of the NFT to validate.
     */
    modifier validNFToken(uint256 _tokenId) {
        require(idToOwner[_tokenId] != address(0));
        _;
    }

    uint256 public constant TOKEN_LIMIT = 512;
    bool public hasSaleStarted = false;
    uint256 public constant PRICE = 300000000000000000;

    bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
    bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
    bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
    bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;

    constructor() {
        _registerInterface(_INTERFACE_ID_ERC165);
        _registerInterface(_INTERFACE_ID_ERC721);
        _registerInterface(_INTERFACE_ID_ERC721_METADATA);
        _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
    }

    function createPunk(uint256 seed) external payable returns (string memory) {
        return _mint(msg.sender, seed);
    }

    function _mint(address _to, uint256 seed) internal returns (string memory) {
        require(_to != address(0));
        require(numTokens < TOKEN_LIMIT);
        require(msg.value >= PRICE, "Insufficient ether sent.");
        require(seedToId[seed] == 0);

        uint256 id = numTokens + 1;

        idToSeed[id] = seed;
        seedToId[seed] = id;

        string memory uri = draw(id);
        emit Generated(id, _to, uri);

        numTokens = numTokens + 1;
        _registerToken(_to, id);

        return uri;
    }

    function _registerToken(address _to, uint256 _tokenId) internal {
        require(idToOwner[_tokenId] == address(0));
        idToOwner[_tokenId] = _to;

        ownerToIds[_to].push(_tokenId);
        uint256 length = ownerToIds[_to].length;
        idToOwnerIndex[_tokenId] = length - 1;

        emit Transfer(address(0), _to, _tokenId);
    }

    function draw(uint256 id) public view returns (string memory) {
        uint256 rand = uint256(keccak256(abi.encodePacked(idToSeed[id])));
        // rand % 1000 // for 0 to 999 inclusive

        string memory hat =
            unicode"            \n"
            unicode"            \n"
            unicode"   ┌────┐   \n";

        string memory eyes =
            unicode"   │    ├┐  \n"
            unicode"   │═ ═ └│  \n"
            unicode"   │ ╘  └┘  \n";

        string memory moustache = unicode"   │    │   \n";

        string memory mouth = unicode"   │──  │   \n";

        string memory chin = unicode"   │    │   \n" unicode"   └──┘ │   \n";

        string memory neck = unicode"     │  │   \n" unicode"     │  │   \n";

        return
            string(abi.encodePacked(hat, eyes, moustache, mouth, chin, neck));
    }

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint256 _tokenId)
        external
        view
        validNFToken(_tokenId)
        returns (string memory)
    {
        return draw(_tokenId);
    }

    /**
     * @dev Function to check which interfaces are suported by this contract.
     * @param _interfaceID Id of the interface.
     * @return True if _interfaceID is supported, false otherwise.
     */
    function supportsInterface(bytes4 _interfaceID)
        external
        view
        returns (bool)
    {
        return _supportedInterfaces[_interfaceID];
    }

    /**
     * @dev Registers the contract as an implementer of the interface defined by
     * `interfaceId`. Support of the actual ERC165 interface is automatic and
     * registering its interface id is not required.
     *
     * See {IERC165-supportsInterface}.
     *
     * Requirements:
     *
     * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
     */

    function _registerInterface(bytes4 interfaceId) internal virtual {
        require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
        _supportedInterfaces[interfaceId] = true;
    }
}
