public with sharing class ExampleClassToMock 
{
    public static ExampleClassToMock newInstance() 
    {
        return (ExampleClassToMock) v_ApexMockRouter.newInstance(ExampleClassToMock.Class);    
    }
    
    public String getName(String name) 
    {
        return name;
    }

    public String getName(String name, String lName) 
    {
        return name + lName;
    }
    
    public Integer getName(Integer nameNumber) 
    {
        return nameNumber;
    }

    public List<User> getUsers() 
    {
        return [SELECT Id, Name FROM User LIMIT 5];    
    }
}