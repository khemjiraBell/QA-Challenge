*** Settings ***
Library            SeleniumLibrary 
Test Setup         Open To Do List Website
Test Teardown      Close All Browsers


*** Variables ***
${URL}    https://abhigyank.github.io/To-Do-List/
${Input_Item}    id=new-task
${Add_BT}    //button
${ToDoTasks_Tab}    //*[@class='mdl-tabs__tab']
${Checkbok}    //*[@class='mdl-checkbox__ripple-container mdl-js-ripple-effect mdl-ripple--center']
${Delete_BT}    (//button[@class='mdl-button mdl-js-button mdl-js-ripple-effect delete'])[1]
${Completed_Tab}    //*[@class='mdl-tabs__tab is-active']/following-sibling::a        
${Completed_Result}    id=completed-tasks
${Delete_BT_Completed}    (//button[contains(@class,'delete')])[last()]
@{E2E_Tasks_List}    1.Respond to urgent emails or messages.    2. Draft or review a project document.    3. Follow up with clients or colleagues.    4. Check in with team members on progress.    5.Update your project management tool or spreadsheet. 

*** Keywords ***
Open To Do List Website
    Open Browser    ${URL}    Chrome
    

Input Tasks
    [Arguments]    ${Input_Task}
    Input Text    ${Input_Item}    ${Input_Task}
    Sleep    2s
    Click Element    ${Add_BT}

TO-DO TASKS Tab
    Click Element    ${ToDoTasks_Tab}
    Wait Until Element Is Visible    ${Checkbok}   5s
    Sleep     5s

Check Checkbox
    Click Element   ${Checkbok}
    Sleep    2s
    Click Element   ${Completed_Tab} 
    Wait Until Element Is Visible    ${Completed_Result}  5s
    Sleep    2s

Delete TO-Do TASKS
    Wait Until Element Is Visible    ${Delete_BT}    5s
    Click Element    ${Delete_BT}
    Sleep    2s


Delete Completed Task
    Wait Until Element Is Visible       ${Delete_BT_Completed}
    Click Element    ${Delete_BT_Completed}
    Sleep   2s


*** Test Cases ***
TC01 Add Item - Blank
    [Tags]    AddItem
    Click Element    ${Add_BT}
    

TC02 Add Item (TH) - Completed
    [Tags]    AddItem
    Input Tasks    ทำอาหารเช้า
    TO-DO TASKS Tab
    Page Should Contain    ทำอาหารเช้า


TC03 Add Item (EN) - Completed
    [Tags]    AddItem
    Input Tasks    Check emails
    TO-DO TASKS Tab
    Page Should Contain    Check emails


TC04 Add Item (์Number and Special Character) - Completed
    [Tags]    AddItem
    Input Tasks    12345*/
    TO-DO TASKS Tab
    Page Should Contain   12345*/


TC05 Verify Checkbox in TO-DO TASKS tab
    [Tags]    ToDoTasks
    Input Tasks    Test
    TO-DO TASKS Tab
    Check Checkbox
    Page Should Contain    Test   
    
    

TC06 Verify Delete button in TO-DO TASKS tab
    [Tags]    ToDoTasks
    Input Tasks    ทดสอบ123456$
    TO-DO TASKS Tab
    Delete TO-Do TASKS
    Page Should Not Contain   ทดสอบ123456$ 



TC07 Verify Completed Item 
    [Tags]    Completed
    Input Tasks    ต้องส่งงานให้หัวหน้าตรวจสอบ ก่อนส่งให้ลูกค้า
    TO-DO TASKS Tab
    Check Checkbox
    Page Should Contain    ต้องส่งงานให้หัวหน้าตรวจสอบ ก่อนส่งให้ลูกค้า
    


TC08 Verify Delete button in COMPLETED tab
    [Tags]    Completed
    Input Tasks    ขอรายละเอียดลูกค้าจากฝ่ายขาย
    TO-DO TASKS Tab
    Check Checkbox
    Delete Completed Task
    Page Should Not Contain    ขอรายละเอียดลูกค้าจากฝ่ายขาย


TC09 Verify E2E Process Flow 3 out of 5 tasks completed
    [Tags]    E2E
    
    FOR    ${task}    IN    @{E2E_Tasks_List}
        Input Tasks    ${task}
    END

    TO-DO TASKS Tab

    #Check_Checkboxes_Flow
    FOR    ${i}    IN RANGE    0    3
    Click Element    ${Checkbok}
    Sleep    1s
    END

    Click Element   ${Completed_Tab} 
    Wait Until Element Is Visible    ${Completed_Result}  5s
    Sleep    5s

    Page Should Contain    ${i}