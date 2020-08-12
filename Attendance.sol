pragma solidity ^0.4.18;


library convert{
    function stringToBytes32(string memory source) internal pure returns (bytes32 result) 
    {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) 
        {
            return 0x0;
        }
    
        assembly 
        {
            result := mload(add(source, 32))
        }
    }
    
    function bytes32ToString(bytes32 x) internal pure returns (string) 
    {
        bytes memory bytesString = new bytes(32);
        uint charCount = 0;
        for (uint j = 0; j < 32; j++) 
        {
            byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
            if (char != 0) 
            {
                bytesString[charCount] = char;
                charCount++;
            }
        }
        bytes memory bytesStringTrimmed = new bytes(charCount);
        for (j = 0; j < charCount; j++) 
        {
            bytesStringTrimmed[j] = bytesString[j];
        }
        return string(bytesStringTrimmed);
    }
    
}



contract Owned 
{
    address owner;
    
    function Owned() public 
    {
        owner = msg.sender;
    }
    
   modifier onlyOwner 
   {
       require(msg.sender == owner);
       _;
   }
}


contract AttendanceSheet is Owned 
{
    
    struct Student 
    {
        uint age;
        bytes32 fName;
        bytes32 lName;
        uint attendanceValue;
    }
    
    mapping (uint => Student) studentList;
    uint[] public studIdList;
    
    event studentCreationEvent(
       bytes32 fName,
       bytes32 lName,
       uint age
    );
    
    
    
    function createStudent(uint _studId, uint _age, string _fName, string _lName) onlyOwner public 
    {
        var student = studentList[_studId];
        
        student.age = _age;
        student.fName = convert.stringToBytes32(_fName);
        student.lName = convert.stringToBytes32(_lName);
        student.attendanceValue = 0;
        studIdList.push(_studId) -1;
        studentCreationEvent(convert.stringToBytes32(_fName), convert.stringToBytes32(_lName), _age);
    }
    
    function incrementAttendance(uint _studId) onlyOwner public {
        studentList[_studId].attendanceValue = studentList[_studId].attendanceValue+1;
    }
    
    function getStudents() view public returns(uint[]) {
        return studIdList;
    }
    
    function getParticularStudent(uint _studId) public view returns (string, string, uint, uint) {
        return (convert.bytes32ToString(studentList[_studId].fName), convert.bytes32ToString(studentList[_studId].lName), studentList[_studId].age, studentList[_studId].attendanceValue);
    }
    
    function noofattendance(uint _studId) public view returns(uint){
        return(studentList[_studId].attendanceValue);
    }

    function countStudents() view public returns (uint) {
        return studIdList.length;
    }
    
}
