local SystemTester = {
    Tests = {},
    _loadedTests = {}
}

function SystemTester.RunTest(TestName)
    local Test = SystemTester._loadedTests[TestName]

    if not Test then
        warn(string.format("Test: %s not found.", TestName))
        return
    end

    print(string.format("Running test: %s", TestName))
    local Pass = Test()

    if Pass then
        print(string.format("%s passed.", TestName))
    else
        print(string.format("%s failed.", TestName))
    end
end

function SystemTester.RunTests()
    print("Running tests in 3 seconds...")

    task.delay(3, function()
        for _, TestName in pairs(SystemTester.Tests) do
            task.spawn(SystemTester.RunTest, TestName)
        end
    end)
end

function SystemTester.LoadTests()
    for _, Test in ipairs(script.Tester:GetChildren()) do
        if not Test:IsA("ModuleScript") then
            continue
        end

        SystemTester._loadedTests[Test.Name] = require(Test)
    end
end

return SystemTester