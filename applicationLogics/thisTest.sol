contract Simple {
	/* uint mainNumber로 function 파라미터와 같은 이름으로 선언하면 동작하지 않는다.
		파라미터와 필드의 이름을 다르게 한다.
	*/
	uint _mainNumber;
        
    function getNum() public returns(uint r_mainNumber){
        r_mainNumber = _mainNumber;
    }
 
    function setNum(uint mainNumber) public{
        _mainNumber = mainNumber;
    }		
}