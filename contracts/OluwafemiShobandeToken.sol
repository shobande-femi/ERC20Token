pragma solidity >=0.4.21 <0.6.0;

import "./ERC20.sol";

/**
 * @title OluwafemiShobandeToken token
 *
 * @dev Implementation of an ERC20 Token
 */
contract OluwafemiShobandeToken is ERC20 {

	address public owner;

	string public name = "OluwafemiShobandeToken";
	string public symbol = "OLS";
	uint8 public decimals = 18;

	mapping (address => uint256) private _balances;

	mapping (address => mapping (address => uint256)) private _allowed;

	uint256 private _totalSupply;

	mapping (address => uint256) private _minters;

	event MinterAdded(address indexed minter);

	event SupplyIncreased(address indexed minter, uint256 value);


	constructor() public {
		owner = msg.sender;
		_minters[msg.sender] = 1;
		_totalSupply = 0;
	}

	/**
	* @dev Total number of tokens in existence
	* @return An uint256 representing the total number of tokens in existence
	*/
	function totalSupply() public view returns (uint256) {
		return _totalSupply;
	}

	/**
	* @dev Gets the balance of the specified address.
	* @param _owner The address to query the balance of.
	* @return An uint256 representing the amount owned by the passed address.
	*/
	function balanceOf(address _owner) public view returns (uint256 balance) {
		return _balances[_owner];
	}

	/**
	* @dev Transfer token for a specified address
	* @param _to The address to transfer to.
	* @param _value The amount to be transferred.
	*/
	function transfer(address _to, uint256 _value) public returns (bool success) {
		require(_to != address(0), "cannot send to address zero");
		require(_value <= _balances[msg.sender], "insufficient funds");

		_balances[msg.sender] -= _value;
		_balances[_to] += _value;

		emit Transfer(msg.sender, _to, _value);
		return true;
	}

	/**
	 * @dev Transfer tokens from one address to another
	 * @param _from address The address which you want to send tokens from
	 * @param _to address The address which you want to transfer to
	 * @param _value uint256 the amount of tokens to be transferred
	 */
	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
		require(_to != address(0), "cannot transfer to address zero");
		require(_value <= _balances[_from], "insufficient funds");
		require(_value <= _allowed[_from][msg.sender], "insufficient allowance");

		_balances[_from] -= _value;
		_balances[_to] += _value;
		_allowed[_from][msg.sender] -= _value;

		emit Transfer(_from, _to, _value);
		return true;
	}

	/**
	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
	 * @param _spender The address which will spend the funds.
	 * @param _value The amount of tokens to be spent.
	 */
	function approve(address _spender, uint256 _value) public returns (bool success) {
		require(_spender != address(0), "cannot add address zero as spender");

		_allowed[msg.sender][_spender] = _value;

		emit Approval(msg.sender, _spender, _value);
		return true;
	}

	/**
	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
	 * @param _owner address The address which owns the funds.
	 * @param _spender address The address which will spend the funds.
	 * @return A uint256 specifying the amount of tokens still available for the spender.
	 */
	function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
		return _allowed[_owner][_spender];
	}

	/**
	 * @dev Throws if called by any account other than the contract owner.
	 */
	modifier onlyOwner() {
		require(msg.sender == owner, "only contract owner can perform this action");
		_;
	}

	/**
	 * @dev Increases the total supply by minting the specified number of tokens to the minter's account.
	 * @param _minter The address of the minter to add.
	 */
	function addMinter(address _minter) public onlyOwner returns (bool success) {
		_minters[_minter] = 1;
		emit MinterAdded(_minter);
		return true;
	}

	/**
	* @dev Check if the specified address has been granted minting rights
	* @param _minter The address to check for minting rights
	* @return An uint256 of 1 if the specified address is minter or 0 otherwise
	 */
	function isMinter(address _minter) public view onlyOwner returns (uint256) {
		return _minters[_minter];
	}

	/**
	 * @dev Throws if called by any account that hasn't been granted minting rights
	 */
	modifier onlyMinter() {
		require(_minters[msg.sender] == 1, "only minters can perform this action");
		_;
	}

	/**
	 * @dev Increases the total supply by minting the specified number of tokens to the minter's account.
	 * @param _value The number of tokens to mint.
	 */
	function mint(uint256 _value) public onlyMinter returns (bool success) {
		_totalSupply += _value;
		_balances[msg.sender] += _value;
		emit SupplyIncreased(msg.sender, _value);
		emit Transfer(address(0), msg.sender, _value);
		return true;
	}
}