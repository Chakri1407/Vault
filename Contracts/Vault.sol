// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "./ERC4626Fees.sol";

/**
 * @title Vault Contract
 * @dev A vault implementation that inherits from ERC4626Fees, allowing for deposits, withdrawals, minting, and redeeming of assets with fees.
 */
contract Vault is ERC4626Fees {
    /// @notice The address of the vault owner (the fee recipient).
    address payable public vaultOwner;

    /// @notice The entry fee in basis points (1 basis point = 0.01%).
    uint256 public entryFeeBasisPoints;

    /**
     * @dev Constructor that initializes the vault with an asset and entry fee.
     * @param _asset The address of the ERC20 asset used by the vault.
     * @param _basisPoints The entry fee in basis points.
     */
    constructor(
        IERC20 _asset,
        uint256 _basisPoints
    ) ERC4626(_asset) ERC20("Vault SKY Token", "VSKY") {
        vaultOwner = payable(msg.sender);
        entryFeeBasisPoints = _basisPoints;
    }

    /**
     * @notice Deposit assets into the vault and receive shares in return.
     * @param assets The amount of assets to deposit.
     * @param receiver The address receiving the vault shares.
     * @return The amount of shares minted for the deposit.
     * @dev See {IERC4626-deposit}.
     */
    function deposit(
        uint256 assets,
        address receiver
    ) public virtual override returns (uint256) {
        require(
            assets <= maxDeposit(receiver),
            "ERC4626: deposit more than max"
        );

        uint256 shares = previewDeposit(assets);
        _deposit(_msgSender(), receiver, assets, shares);
        afterDeposit(assets);

        return shares;
    }

    /**
     * @notice Mint vault shares for the receiver by providing assets.
     * @param shares The number of shares to mint.
     * @param receiver The address receiving the minted shares.
     * @return The amount of assets required for minting the shares.
     * @dev See {IERC4626-mint}. Minting is allowed even if the price of a share is zero.
     */
    function mint(
        uint256 shares,
        address receiver
    ) public virtual override returns (uint256) {
        require(shares <= maxMint(receiver), "ERC4626: mint more than max");

        uint256 assets = previewMint(shares);
        _deposit(_msgSender(), receiver, assets, shares);
        afterDeposit(assets);

        return assets;
    }

    /**
     * @notice Withdraw assets from the vault by burning the corresponding shares.
     * @param assets The amount of assets to withdraw.
     * @param receiver The address receiving the withdrawn assets.
     * @param owner The address of the owner of the shares.
     * @return The amount of shares burned for the withdrawal.
     * @dev See {IERC4626-withdraw}.
     */
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) public virtual override returns (uint256) {
        require(
            assets <= maxWithdraw(owner),
            "ERC4626: withdraw more than max"
        );

        uint256 shares = previewWithdraw(assets);
        beforeWithraw(assets, shares);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return shares;
    }

    /**
     * @notice Redeem vault shares for the corresponding assets.
     * @param shares The number of shares to redeem.
     * @param receiver The address receiving the assets.
     * @param owner The address of the owner of the shares.
     * @return The amount of assets redeemed for the shares.
     * @dev See {IERC4626-redeem}.
     */
    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) public virtual override returns (uint256) {
        require(shares <= maxRedeem(owner), "ERC4626: redeem more than max");

        uint256 assets = previewRedeem(shares);
        beforeWithraw(assets, shares);
        _withdraw(_msgSender(), receiver, owner, assets, shares);

        return assets;
    }

    // === Fee configuration ===

    /**
     * @notice Returns the entry fee in basis points.
     * @return The entry fee in basis points.
     */
    function _entryFeeBasisPoints() internal view override returns (uint256) {
        return entryFeeBasisPoints;
    }

    /**
     * @notice Returns the address that receives the entry fee.
     * @return The address of the fee recipient.
     */
    function _entryFeeRecipient() internal view override returns (address) {
        return vaultOwner;
    }

    /*////////////////////////////////////////////////////////////////////////
                       INTERNAL HOOKS LOGIC
    ////////////////////////////////////////////////////////////////////////*/

    /**
     * @dev Hook that can be overridden to add logic before a withdrawal.
     * @param assets The amount of assets to withdraw.
     * @param shares The amount of shares to burn for the withdrawal.
     */
    function beforeWithraw(uint256 assets, uint256 shares) internal virtual {}

    /**
     * @dev Hook that can be overridden to add logic after a deposit.
     * @param assets The amount of assets deposited.
     * @notice A fee of 10% (1/10) is transferred to the vault owner as interest.
     */
    function afterDeposit(uint256 assets) internal virtual {
        uint256 interest = assets / 10;
        SafeERC20.safeTransferFrom(
            IERC20(asset()),
            vaultOwner,
            address(this),
            interest
        );
    }
}
