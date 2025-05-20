// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract VaultManager {
    struct Vault {
        string name;
        address creator;
        uint256 minParticipants;
        uint256 totalParticipants;
        uint256 totalSaved;
        bool active;
    }

    mapping(uint256 => Vault) public vaults;
    mapping(uint256 => mapping(address => uint256)) public userSavings;
    uint256 public vaultCount;

    event VaultCreated(uint256 id, address creator, string name);
    event Deposit(uint256 vaultId, address user, uint256 amount);

    function createVault(string memory _name, uint256 _minParticipants) external {
        vaults[vaultCount] = Vault({
            name: _name,
            creator: msg.sender,
            minParticipants: _minParticipants,
            totalParticipants: 0,
            totalSaved: 0,
            active: true
        });

        emit VaultCreated(vaultCount, msg.sender, _name);
        vaultCount++;
    }

    function depositToVault(uint256 vaultId) external payable {
        require(vaults[vaultId].active, "Vault no activo");
        require(msg.value > 0, "Debes enviar fondos");

        userSavings[vaultId][msg.sender] += msg.value;
        vaults[vaultId].totalSaved += msg.value;

        emit Deposit(vaultId, msg.sender, msg.value);
    }

    function getMySavings(uint256 vaultId) external view returns (uint256) {
        return userSavings[vaultId][msg.sender];
    }

    function getVaultInfo(uint256 vaultId) external view returns (Vault memory) {
        return vaults[vaultId];
    }
}
