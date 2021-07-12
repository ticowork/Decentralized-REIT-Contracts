// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Snapshot.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";


contract DRT is ERC20, ERC20Burnable, ERC20Snapshot, AccessControl {
    using SafeMath for uint256;

    uint256 constant _initialSupply = 21000000000 * (10 ** 18);
    uint256 constant _minimumSupply = 17800000000 * (10 ** 18);
    bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
    

    constructor() ERC20("Decentralized REIT", "DRT") {
        _setupRole(SNAPSHOT_ROLE, msg.sender);
        _mint(msg.sender, _initialSupply);
    }   

    function setSnapshotRole(address address_) external {
        require(hasRole(SNAPSHOT_ROLE, msg.sender));
        _setupRole(SNAPSHOT_ROLE, address_);
    }
    
    function snapshot() public {
        require(hasRole(SNAPSHOT_ROLE, msg.sender));
        _snapshot();
    }
    
    function burn(uint256 amount) public override virtual {
        _limitBurn(amount);
    }
    
    
    function _limitBurn(uint256 amount) internal {
        require(totalSupply().sub(amount) > _minimumSupply, "Burn limit reached");
        _burn(msg.sender, amount);
        
    }
    
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20, ERC20Snapshot)
    {
        super._beforeTokenTransfer(from, to, amount);
    }

}