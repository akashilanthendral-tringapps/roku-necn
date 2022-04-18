sub init()
    ' m.top.observeField("focusedChild", "setFocusToMyList")

    m.topRect = m.top.findNode("topRect")
    m.topRectTranslations = ["[0,0]", "[-300,0]", "[-600,0]", "[0,0]", "[-300,0]", "[-600,0]"]

    m.topRectAnimationRightMovingScreen = m.top.findNode("topRectAnimationRightMovingScreen")
    m.topRectAnimationLeftMovingScreen = m.top.findNode("topRectAnimationLeftMovingScreen")

    m.topRectInterpRightMovingScreen = m.top.findNode("topRectInterpRightMovingScreen")
    m.topRectInterpLeftMovingScreen = m.top.findNode("topRectInterpLeftMovingScreen")

    m.layoutGroupId = m.top.findNode("layoutGroupId")

    m.playButton = m.top.findNode("playButton")
    m.playButton.setFocus(true)
    m.buttonGroupId = m.top.findNode("buttonGroupId")
    m.leftMarkUpGridList = m.top.findNode("leftMarkUpGridList")
    m.leftMarkUpGridList.observeField("itemFocused", "onMarkUpGridFocused")
    m.leftMarkUpGridList.observeField("itemUnfocused", "onMarkUpGridUnfocused")
    m.leftMarkUpGridList.observeField("itemSelected", "onMarkUpGridSelected")
    m.isFirstTimeInsideOnMarkUpGridFocused = true
    
    'm.leftMarkUpGridListAnimation = m.top.findNode("leftMarkUpGridListAnimation")
    'm.leftMarkUpGridListAnimationWhenUnfocused = m.top.findNode("leftMarkUpGridListAnimationWhenUnfocused")
    ' m.markUpGridBackgroundWhenFocused = m.top.findNode("markUpGridBackgroundWhenFocused")
    ' m.markUpGridBackgroundWhenUnfocused = m.top.findNode("markUpGridBackgroundWhenUnfocused")
    
    m.homeComponentId = m.top.findNode("homeComponentId")
    m.searchComponentId = m.top.findNode("searchComponentId")
    m.profileComponentId = m.top.findNode("profileComponentId")
    m.timeGridComponentId = m.top.findNode("timeGridComponentId")
    
    m.componentsArray = [m.homeComponentId, m.searchComponentId, m.profileComponentId, m.timeGridComponentId]
    m.previousComp = m.homeComponentId
    m.playButton.observeField("buttonSelected", "onPlayButtonSelected")

    ' m.secondVideoMUG = m.searchComponentId.findNode("secondVideoMUG")
    ' m.secondVideoMUG.observeField("itemFocused", "onSecondVideoMUGFocused")
    ' m.secondVideoMUG.observeField("itemUnfocused", "onSecondVideoMUGUnfocused")
    ' m.previouslyFocusedSecondVideoItemIndex = -1
 

    setLeftMarkUpGridItems()
    setHomeComponent()
end sub

sub onMarkUpGridUnfocused()
    print "onMarkUpGridUnfocused()"
    if m.leftMarkUpGridList.hasFocus()
        m.unfocusedItemIndex = m.leftMarkUpGridList.itemUnfocused
        m.unfocusedItem = m.leftMarkUpGridList.content.getChild(m.unfocusedItemIndex)
        m.unfocusedItem.setIconVisible = false
        m.unfocusedItem.setNameVisible = 0.5
    end if
end sub

sub onMarkUpGridFocused()
    print "onMarkUpGridFocused()"
    if m.isFirstTimeInsideOnMarkUpGridFocused
        print "if m.isFirstTimeInsideOnMarkUpGridFocused = true"
        m.isFirstTimeInsideOnMarkUpGridFocused = false 
        m.focusedItemIndex = m.leftMarkUpGridList.itemFocused 
        m.lastFocusedItemIndex = m.focusedItemIndex
        m.focusedItem = m.leftMarkUpGridList.content.getChild(m.focusedItemIndex)
        m.focusedItem.setIconVisible = true
        m.focusedItem.setNameVisible = 1.0
    else
        print "if m.isFirstTimeInsideOnMarkUpGridFocused = false"
        m.focusedItemIndex = m.leftMarkUpGridList.itemFocused 
        m.lastFocusedItemIndex = m.focusedItemIndex
        m.focusedItem = m.leftMarkUpGridList.content.getChild(m.focusedItemIndex)
        m.focusedItem.setIconVisible = true
        m.focusedItem.setNameVisible = 1.0
    end if
end sub

sub setHomeComponent()
    m.homeComponentId.visible = true
    m.previousComp = m.homeComponentId
    m.previousComp.setFocus = true
end sub

sub onMarkUpGridSelected()
    
    selectedItemIndex = m.leftMarkUpGridList.itemSelected
    m.selectedItemOfLeftMarkUpGrid = selectedItemIndex
    print "selected item: "m.selectedItemOfLeftMarkUpGrid 
    selectedItem = m.leftMarkUpGridList.content.getChild(selectedItemIndex)
    selectedItem.setIconVisible = false 
    if selectedItem.name = "Sign out"
        onLogoutButtonSelected()
    else 
        renderComponent()
    end if
end sub

sub renderComponent()

    selectedItemIndex = m.leftMarkUpGridList.itemSelected
    selectedItem = m.leftMarkUpGridList.content.getChild(selectedItemIndex)
    compName = selectedItem.componentName
    compToRender = m.top.findNode(compName)

    compToRender.observeField("toParentData", "handleToParentData")

    'm.leftMarkUpGridListAnimationWhenUnfocused.control = "start"
    ' m.markUpGridBackgroundWhenUnfocused.control = "start"

    m.previousComp.setFocus = false
    m.previousComp.visible = false
    m.previousComp = compToRender
    compToRender.setFocus = true
    compToRender.visible = true
    ' i = 0
    ' while i < m.componentsArray.Count()
    '     print "Inside while"
    '     if i <> selectedItem
            
    '         m.componentsArray[i].setFocus = false
    '         m.componentsArray[i].visible = false
    '     else
    '         print "i = selectedItem: "i
    '         print "setfocus triggered"
    '         print "item selected: "m.leftMarkUpGridList.content.getChild(selectedItem)
    '         m.leftMarkUpGridListAnimationWhenUnfocused.control = "start"
           ' m.markUpGridBackgroundWhenUnfocused.control = "start"
    '         m.componentsArray[i].visible = true
    '         m.componentsArray[i].setFocus = true
            
    '         m.previousComp = m.componentsArray[i]
    '     end if
    '     i = i + 1
    ' end while
    
    ' if selectedItem = 0
        
    ' else if selectedItem = 3
    '     comp = m.componentsArray[0]
    '     m.previousComp = comp 
    '     m.playButton.setFocus(false)
    '     comp.visible = true
    '     comp.setFocus = true
    ' end if

end sub

sub renderLiveComponent()
    timeGridComponent = CreateObject("rosgnode", "timeGridComponent")
    m.top.appendChild(timeGridComponent)
    timeGridComponent.setFocus(true)
end sub

sub setLeftMarkUpGridItems()

    m.markUpGridItemContents = [
        {
            "name": "Home",
            "iconUri": "pkg:/images/separated/sideBarIcon.png",
            ' "iconUri": "pkg:/images/separated/homeIconColored.png",
            "componentName": "homeComponentId"            
        },
        {
            "name": "Search",
            "iconUri": "pkg:/images/separated/sideBarIcon.png",
            ' "iconUri": "pkg:/images/separated/searchIconBlue2.png",
            "componentName": "searchComponentId"
        },
        {
            "name": "Profile",
            "iconUri": "pkg:/images/separated/sideBarIcon.png",
            ' "iconUri": "pkg:/images/separated/profileIcon.png",
            "componentName": "profileComponentId"
        },
        {
            "name": "Live",
            "iconUri": "pkg:/images/separated/sideBarIcon.png",
            ' "iconUri": "pkg:/images/separated/liveIcon.png",
            "componentName": "timeGridComponentId"
        },
        {
            "name": "Sign out",
            "iconUri": "pkg:/images/separated/sideBarIcon.png",
            ' "iconUri": "pkg:/images/separated/signoutIcon.png",
            "componentName": ""
        }
    ]


    parentContent = CreateObject("roSGNode", "contentNode")

    for each item in m.markUpGridItemContents
        childContent = parentContent.createChild("leftMarkUpGridContent")
        childContent.iconUri = item.iconUri
        childContent.name = item.name
        childContent.componentName = item.componentName
        if item.name = "Home"
            childContent.setIconVisible = false
            childContent.setNameVisible = 1.0
        else 
            childContent.setIconVisible = false
            childContent.setNameVisible = 0.5
        end if
    end for

    m.leftMarkUpGridList.content = parentContent
end sub

' sub setFocusToMyList()

'     if m.top.hasFocus()
'         m.leftMarkUpGridList.setFocus(true)
'         m.leftMarkUpGridListAnimation.control = "start"
        ' m.markUpGridBackgroundWhenFocused.control = "start"
'     end if

' end sub

sub onLogoutButtonSelected()
    m.top.getScene().deleteBackStackArray = true
    m.top.getScene().logOut = true
    m.top.getScene().compToPush = "loginComponent"

end sub

sub onPlayButtonSelected()
    m.selectedItemOfLeftMarkUpGrid = 0
    m.top.getScene().compToPush = "videoComponent"
end sub


sub handleFromChildData()
    print "handleFromChildData()"
    print "m.selectedItemOfLeftMarkUpGrid: "m.selectedItemOfLeftMarkUpGrid
    if m.selectedItemOfLeftMarkUpGrid = 0
        m.playButton.setFocus(true)
    else if m.selectedItemOfLeftMarkUpGrid = 1
        m.searchComponentId.afterOnFirstVideoMUGSelected = true
        ' if m.previouslyFocusedSecondVideoItemIndex = -1
        '     m.searchComponentId.afterOnFirstVideoMUGSelected = "true"
        ' else
        '     m.secondVideoMUG.setFocus(true)
        '     m.focusedItem.secondTimeRenderingSecondVideo = {
        '         "isSecondTime": true
        '         "control": "play"
        '     }
        ' end if
    else 
        m.leftMarkUpGridList.setFocus(true)
    end if
    
end sub

function onKeyEvent(key as string, press as boolean) as boolean
    if press
        if key = "right"
            print "Right key pressed"
            if m.leftMarkUpGridList.hasFocus()
                print "m.leftMarkUpGridList.hasFocus(): "m.leftMarkUpGridList.hasFocus()
                'm.leftMarkUpGridListAnimationWhenUnfocused.control = "start"
                ' m.markUpGridBackgroundWhenUnfocused.control = "start"
                itemFoc = m.leftMarkUpGridList.content.getChild(m.leftMarkUpGridList.itemFocused)
                itemFoc.setIconVisible = false
                m.previousComp.setFocus = true
                return true
            end if
        else if key = "left"
            print "left pressed"
            ' if m.secondVideoMUG.hasFocus()
            '     ' stopSecondVideo()
            '     m.searchComponentId.playFirstVideo = true
            '     return true
             if m.playButton.hasFocus()
                print "m.playButton.hasFocus()"
                'm.leftMarkUpGridListAnimation.control = "start"
                ' m.markUpGridBackgroundWhenFocused.control = "start"
                m.playButton.setFocus(false)
                m.leftMarkUpGridList.setFocus(true)
                return true
            else if NOT m.leftMarkUpGridList.hasFocus() 
                print "NOT m.leftMarkUpGridList.hasFocus()"
                'm.leftMarkUpGridListAnimation.control = "start"
                ' m.markUpGridBackgroundWhenFocused.control = "start"
                m.leftMarkUpGridList.setFocus(true)
                return true
            else
                print "else part handled"
                ' m.leftMarkUpGridListAnimation.control = "start"
                ' m.markUpGridBackgroundWhenFocused.control = "start"
                m.leftMarkUpGridList.setFocus(true)
            end if
        
        else if key = "back"
            ' m.leftMarkUpGridList.setFocus(true)
            ' if m.secondVideoMUG.hasFocus()
            '     ' stopSecondVideo()
            '     m.topRect.translation = "[0,0]"
            '     m.leftMarkUpGridListAnimation.control = "start"
            '     m.leftMarkUpGridList.setFocus(true)
            '     return true
            if m.leftMarkUpGridList.hasFocus()
                return true
            end if
            'm.leftMarkUpGridListAnimation.control = "start"
            ' m.markUpGridBackgroundWhenFocused.control = "start"
            m.leftMarkUpGridList.setFocus(true)
            return true
        else if key = "ok"
            if m.leftMarkUpGridList.hasFocus()

            end if
        end if
    return false
    end if
end function

sub handleToParentData(event)
    dataFromChild = event.getData()
    if dataFromChild.action = "componentCreation"
        m.top.toChildData = dataFromChild.pageData
        m.top.getScene().compToPush = dataFromChild.componentName
    else if dataFromChild.action = "moveScreen"
        if dataFromChild.component = "searchComponent"
            secondVideoMUGWidth = dataFromChild.spaceToMove
            moveScreen(dataFromChild.direction, dataFromChild.spaceToMove)
        end if
        
    end if
end sub

' sub onSecondVideoMUGFocused()
'     print "Inside onSecondVideoMUGFocused()"
'     print "onSecondVideoMUGFocused()"
'     m.focusedItemIndex = m.secondVideoMUG.itemFocused
'     if m.previouslyFocusedSecondVideoItemIndex = -1
'         m.previouslyFocusedSecondVideoItemIndex = 0
'     end if
'     print "m.focusedItemIndex: "m.focusedItemIndex

'     if m.focusedItemIndex <> 0 or m.focusedItemIndex <> 3
'         print "......................"
'         print "Inside IF"
'         print "m.previouslyFocusedSecondVideoItemIndex : "m.previouslyFocusedSecondVideoItemIndex 
'         print "m.focusedItemIndex: "m.focusedItemIndex

'         moveScreen()        
'     end if

'     m.focusedItem = m.secondVideoMUG.content.getChild(m.focusedItemIndex)
'     m.lastFocusedItemOfSecondVideo = m.focusedItem
'     m.focusedItem.secondTimeRenderingSecondVideo = {
'         "isSecondTime": true
'         "control": "play"
'     }
' end sub

sub moveScreen(direction, spaceToMove)
    print "moveScreen()"
    print "direction: "direction
    print "spaceToMove: "spaceToMove
    xCoordinate = m.topRect.translation[0]
    if direction = "right"
        
        m.topRectInterpRightMovingScreen.keyValue = [[xCoordinate, 0], [xCoordinate-spaceToMove, 0]]
        m.topRectAnimationRightMovingScreen.control = "start"

        ' m.topRectInterpRightMovingScreen.keyValue = [[xCoordinate, 0], [xCoordinate-300, 0]]
        ' m.topRectAnimationRightMovingScreen.control = "start"

        ' xCoordinate = xCoordinate - 300
        ' m.topRect.translation = [xCoordinate, 0]
        ' print "m.topRect.translation: "m.topRect.translation
        ' xCoordinate = m.topRect.translation[0]
        
    else if direction="left"
        
        m.topRectInterpLeftMovingScreen.keyValue = [[xCoordinate, 0], [xCoordinate+spaceToMove, 0]]
        m.topRectAnimationLeftMovingScreen.control = "start"
        ' xCoordinate = m.topRect.translation[0]
        ' xCoordinate = xCoordinate + 300
        ' m.topRect.translation = [xCoordinate, 0]
        ' print "m.topRect.translation: "m.topRect.translation
    else
        m.topRectInterpLeftMovingScreen.keyValue = [[xCoordinate, 0], [0, 0]]
        m.topRectAnimationLeftMovingScreen.control = "start"
        'm.topRect.translation = [0,0]
    end if
    ' m.topRect.translation= m.topRectTranslations[m.focusedItemIndex]
    ' m.topRect.translation[0] =  m.topRect.translation[0] - 100
    ' if leftOrRight = "right"
    '     print "leftOrRight = right"
    '     print "m.topRect.translation[0]: "m.topRect.translation[0]
    '     m.topRect.translation= m.topRectTranslations[m.focusedItemIndex]
    '     print "m.topRect.translation[0]: "m.topRect.translation[0]
    ' else
    '     print "leftOrRight = left"
    '     print "m.topRect.translation[0]: "m.topRect.translation[0]
    '     m.topRect.translation[0] = m.topRect.translation[0] + 100
    '     print "m.topRect.translation: "m.topRect.translation
    ' end if
    
end sub

' sub onSecondVideoMUGUnfocused()
'     m.lastFocusedItemOfSecondVideo.secondTimeRenderingSecondVideo = {
'         "isSecondTime" : true,
'         "control": "stop"
'     }
' end sub
' sub stopSecondVideo()
'     m.lastFocusedItemOfSecondVideo.secondTimeRenderingSecondVideo = {
'         "isSecondTime": true
'         "control": "stop"
'     }
' end sub