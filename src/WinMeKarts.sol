pragma solidity 0.8.20;
//SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WinMeKarts is ERC721Enumerable, Ownable {
    using Strings for uint256;
    
    address payable public treasury; /*recipient for ETH*/

    string public baseURI; /*baseURI_ String to prepend to token IDs*/

    string public contractURI; /*contractURI contract metadata json*/

    uint256 private _tokenIds;

    /// @dev Construtor sets the token and sale params
    /// @param baseURI_ String to prepend to token IDs
    // / @param _contractURI Contract metadata json location
    /// @param _treasury Recipient of sale ETH
    constructor(
        string memory baseURI_,
        address payable _treasury
    ) ERC721("WinMeCars", "WMK") Ownable(msg.sender) {
        _setBaseURI(baseURI_);
        treasury = _treasury;
    }

    /*****************
    CONFIG FUNCTIONS
    *****************/

    /// @notice Set new base URI for token IDs
    /// @param baseURI_ String to prepend to token IDs
    function setBaseURI(string memory baseURI_) external onlyOwner {
        _setBaseURI(baseURI_);
    }

    /// @notice Set new contract URI
    /// @param _contractURI Contract metadata json
    function setContractURI(string memory _contractURI) external onlyOwner {
        contractURI = _contractURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require((tokenId <= _tokenIds), "ERC721Metadata: URI query for nonexistent token");
        string memory _baseURI_ = _baseURI();
        return bytes(_baseURI_).length > 0 ? string(abi.encodePacked(_baseURI_, (tokenId%4).toString(), ".json")) : "";
    }
    
    /*****************
    EXTERNAL MINTING FUNCTIONS
    *****************/

    /// @notice Mint
    function mintNft(address _to) external onlyOwner {
        _mintItem(_to);
    }

    /*****************
    INTERNAL MINTING FUNCTIONS AND HELPERS
    *****************/

    /// @notice Mint tokens from presale and public pool
    /// @dev Token IDs come from separate pool after reserve
    /// @param _to Recipient of reserved tokens
    function _mintItem(address _to) internal {
        _tokenIds+=1;
        _safeMint(_to, _tokenIds);
    }

    /// @notice internal helper to retrieve private base URI for token URI construction
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    /// @notice internal helper to update token URI
    /// @param baseURI_ String to prepend to token IDs
    function _setBaseURI(string memory baseURI_) internal {
        baseURI = baseURI_;
    }
}