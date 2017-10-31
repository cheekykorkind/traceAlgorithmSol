	/* React Native에서 promise.all을 실행이 목표다.
		1. 테스트 명 : array의 length return 받기
		2. debugger-ui : 아래와 같은 형태로 리턴된다.
			BigNumber {s: 1, e: 0, c: Array(1)}
		3. React Native : 아래와 같은 형태로 접근한다.
			result.c[0]
		4. 알게된 점 : 브로드캐스팅 속도인지, mining 속도인지 정확하지는 않지만 setter 실행후 블록 6개 쌓을정도의 시간이 필요했다.
	*/
	
contract Simple {
    uint[] public ary;
    
    function sendCurrentTx() public {
        ary.push(22);
        ary.push(33);
    }
    function getMappingLength() constant returns(uint){
        return ary.length;
    }
}

