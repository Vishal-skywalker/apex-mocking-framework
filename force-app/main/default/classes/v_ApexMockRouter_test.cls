@IsTest
public with sharing class v_ApexMockRouter_test 
{
    @IsTest
    static void newInstance_test()
    {
        Assert.isInstanceOfType(v_ApexMockRouter.newInstance(ExampleClassToMock.Class), ExampleClassToMock.Class);
    }

    @IsTest
    static void setMock_test()
    {
        v_ApexMockRouter.setMock(10, ExampleClassToMock.Class);
        Assert.areEqual(10, (Integer) v_ApexMockRouter.newInstance(ExampleClassToMock.Class));
    }
}