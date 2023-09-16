public with sharing class v_ApexMockRouter 
{
    private static Map<Type, Object> typeVsMockObject = new Map<Type, Object>();

    /**
     * Method intended to be used in test context only to set mocking.
     * @see `ExampleClassToMock_test` for how to?
     */
    @TestVisible
    private static void setMock(Object o, Type t) 
    {
        typeVsMockObject.put(t, o);
    }

    /**
     * All service, selector and unitOfworks should be called using this method instead of new keyword
     * @see `ExampleClasToMock` for how to?
     */
    public static Object newInstance(Type t)
    {
        if (typeVsMockObject.containsKey(t)) return typeVsMockObject.get(t);
        return t.newInstance();
    }
}