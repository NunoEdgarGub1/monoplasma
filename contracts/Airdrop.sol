pragma solidity ^0.4.24;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

import "./AbstractRootChain.sol";
import "./Ownable.sol";

/**
 * Continuous airdrop where recipients can withdraw tokens allocated in side-chain.
 * Simplest root chain contract implementation
 */
contract Airdrop is AbstractRootChain, Ownable {
    using SafeMath for uint256;

    IERC20 public token;
    mapping (address => uint) public withdrawn;

    constructor(address tokenAddress) Ownable() public {
        token = IERC20(tokenAddress);
    }

    /**
     * Owner creates the side-chain blocks
     */
    function onRecordBlock(uint, bytes32, string) internal {
        require(msg.sender == owner, "error_notPermitted");
    }

    /**
     * Called from AbstractRootChain.proveSidechainBalance, perform payout directly
     */
    function onVerifySuccess(uint, address account, uint balance) internal {
        require(withdrawn[account] < balance, "err_oldEarnings");
        uint withdrawable = balance.sub(withdrawn[account]);
        withdrawn[account] = balance;
        require(token.transfer(account, withdrawable), "err_transfer");
    }
}
