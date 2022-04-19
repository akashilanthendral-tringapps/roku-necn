sub init()

    print "init() of SEARCH component"
    print "m.top: "m.top
    m.top.observeField("visible", "onVisibilityChanged")
    m.firstVideoMUG = m.top.findNode("firstVideoMUG")
    
    ' m.firstVideoMUG.observeField("itemFocused", "onFirstVideoMUGFocused")
    m.firstVideoMUG.observeField("itemUnfocused", "onFirstVideoMUGUnfocused")
    m.firstVideoMUG.observeField("itemSelected", "onFirstVideoMUGSelected")

    m.secondVideoMUG = m.top.findNode("secondVideoMUG")
    m.secondVideoMUG.observeField("itemFocused", "onSecondVideoMUGFocused")
    m.secondVideoMUG.observeField("itemUnfocused", "onSecondVideoMUGUnfocused")
    m.secondVideoMUG.observeField("itemSelected", "onSecondVideoMUGSelected")

    m.outerLayoutGroup = m.top.findNode("outerLayoutGroup")

    m.isFirstVideoEnlarged = false
    m.isSecondVideoEnlarged = false
    m.isFirstTimeFirstVideoMUGGotFocused = true
    m.isFirstTimeInsideOnSecondVideoMUGFocused = true

    'For handling onSecondVideoMUGFocused()
    m.isFirstTimeInsideOnSecondVideoMUGFocused = true
    m.totalScreenWidth = 1920
    m.totalWidthOccByFirstMUG = m.firstVideoMUG.itemSize[0] + m.outerLayoutGroup.itemSpacings[0]
    
    m.totalWidthOccBySecondMUG = m.totalScreenWidth - m.outerLayoutGroup.translation[0] - m.totalWidthOccByFirstMUG
    m.minWidthOfSecondMUGWhereNoTranslation = m.totalWidthOccBySecondMUG

    m.sizeOfAnItem = m.secondVideoMUG.itemSpacing[0] + m.secondVideoMUG.itemSize[0]
    m.sizeOfNextVideoToBeVisible = 50

end sub

sub onVisibilityChanged()
    if m.top.visible = true
        renderFirstVideoComponent()
        renderSecondVideoComponent()
    end if
end sub

sub onFirstVideoMUGUnfocused()
    print "onFirstVideoMUGUnfocused(): "
    ' m.firstVideoChildContent.setBgi= true
    stopFirstVideo()
end sub

sub onSecondVideoMUGUnfocused()
   
    print "onSecondVideoMUGUnfocused()"
    ' m.lastFocusedItemOfSecondVideo.secondTimeRenderingSecondVideo = {
    '     "isSecondTime" : true,
    '     "control": "stop"
    ' }
    m.previousFocusedColumn = m.secondVideoMUG.itemUnfocused
    print "...................."
    print "m.previousFocusedColumn: "m.previousFocusedColumn
    if m.previousFocusedColumn >= m.secondVideoMUG.numColumns
        m.previousFocusedColumn = m.previousFocusedColumn mod m.secondVideoMUG.numColumns
    end if
    print "...................."
    print "m.previousFocusedColumn: "m.previousFocusedColumn
    stopSecondVideo()
end sub

sub onFirstVideoMUGFocused()
    print "onFirstVideoMUGFocused()"
    ' print ".................."
    ' print "onFirstVideoMUGFocused()"
    ' if m.isFirstTimeFirstVideoMUGGotFocused
    '     m.isFirstTimeFirstVideoMUGGotFocused = false
    ' else
    '     playFirstVideo()
    ' end if
        'renderFirstVideoComponent()

    ' else
    '     print "not first time"
    '     if m.firstVideoMUG.hasFocus()
    '         print "m.firstVideoMUG.hasFocus()"
    '         print "m.firstVideoChildContent: "m.firstVideoChildContent
    '         m.firstVideoChildContent.secondTimeRenderingFirstVideo = {
    '             "isSecondTime" : true,
    '             "control": "play"
    '         }
    '     end if
    ' end if
    'playFirstVideo()
end sub

sub onSecondVideoMUGFocused()

    print "onSecondVideoMUGFocused()"
    print "m.secondVideoMUG.change: "m.secondVideoMUG.change
    m.focusedItemIndex = m.secondVideoMUG.itemFocused
    if m.isFirstTimeInsideOnSecondVideoMUGFocused
        m.isFirstTimeInsideOnSecondVideoMUGFocused = false
        m.previousFocusedColumn = m.focusedItemIndex
    end if

    m.focusedItem = m.secondVideoMUG.content.getChild(m.focusedItemIndex)
    m.lastFocusedItemOfSecondVideo = m.focusedItem  
    focusedCol = m.secondVideoMUG.currFocusColumn
    m.spaceToMove = 0
    print "m.previousFocusedColumn: "m.previousFocusedColumn
    if m.secondVideoMUG.horizFocusDirection = "right"
        print "-------------------------"
        print "m.previousFocusedColumn: "m.previousFocusedColumn
        m.spaceToMove = m.sizeOfAnItem * (focusedCol - m.previousFocusedColumn)
        m.top.toParentData = {
            "action": "moveScreen",
            "component": "searchComponent"
            "direction": "right",
            "spaceToMove": m.spaceToMove
        }
    else if m.secondVideoMUG.horizFocusDirection = "left"
        print "-------------------------"
        print "m.previousFocusedColumn: "m.previousFocusedColumn
        m.spaceToMove = m.sizeOfAnItem * (m.previousFocusedColumn - focusedCol)
        m.top.toParentData = {
            "action": "moveScreen",
            "component": "searchComponent"
            "direction": "left",
            "spaceToMove": m.spaceToMove
        }
    else if m.secondVideoMUG.horizFocusDirection = "none"
        print "INSIDE NONE"
        if m.secondVideoMUG.hasFocus()
            print "INSIDE if m.secondVideoMUG.hasFocus()"
            if m.previousFocusedColumn <> focusedCol
                print "if m.previousFocusedColumn <> focusedCol"
                ' m.spaceToMove = (focusedCol + 1) * m.sizeOfAnItem
                print "m.previousFocusedColumn: "m.previousFocusedColumn
                print "focusedCol: "focusedCol
                
                if m.previousFocusedColumn - focusedCol > 0
                    m.spaceToMove = m.sizeOfAnItem * (m.previousFocusedColumn - focusedCol)
                    m.top.toParentData = {
                        "action": "moveScreen",
                        "component": "searchComponent"
                        "direction": "left",
                        "spaceToMove": m.spaceToMove
                    }
                else
                    m.spaceToMove = m.sizeOfAnItem * (focusedCol - m.previousFocusedColumn)
                    m.top.toParentData = {
                        "action": "moveScreen",
                        "component": "searchComponent"
                        "direction": "right",
                        "spaceToMove": m.spaceToMove
                    }
                end if
            end if
        end if
        
    end if
    
    playSecondVideo()
    ' m.focusedItem.secondTimeRenderingSecondVideo = {
    '     "isSecondTime": true
    '     "control": "play"
    ' }
end sub

sub onFirstVideoMUGSelected()
    print "onFirstMUGSelected()"
    m.gridItemSelected = "firstVideoMUG"
    ' m.firstVideoChildContent.firstVideoControl = "stop"
    m.firstVideoChildContent.secondTimeRenderingFirstVideo = {
        "isSecondTime": true
        "control": "stop"
    }
    pageData = {
        "title": m.firstVideoChildContent.firstVideoTitle,
        "control": m.firstVideoChildContent.firstVideoControl,
        "url": m.firstVideoChildContent.firstVideoUrl,
        "streamFormat": m.firstVideoChildContent.firstVideoStreamFormat
    }
    m.top.toParentData = {
        "action": "componentCreation",
        "componentName": "fullScreenVideoComponent"
        "pageData": pageData
        
    }
    ' m.top.getScene().valuesToTopComponent = getFirstVideoDetails()
    ' m.top.getScene().compToPush = "fullScreenVideoComponent"
end sub

sub handleAfterOnFirstVideoMUGSelected()
    print "handleAfterOnFirstVideoMUGSelected()"
    if m.gridItemSelected = "firstVideoMUG"
        m.firstVideoMUG.setFocus(true)
        playFirstVideo()
        ' m.firstVideoChildContent.firstVideoControl = "play"
        ' m.firstVideoChildContent.secondTimeRenderingFirstVideo = {
        '     "isSecondTime": true
        '     "control": "play"
        ' }
    else if m.gridItemSelected = "secondVideoMUG"
        m.secondVideoMUG.setFocus(true)
        playSecondVideo()
        ' m.secondVideoSelected.secondVideoControl = "play"
        ' m.lastFocusedItemOfSecondVideo.secondTimeRenderingSecondVideo = {
        '     "isSecondTime": true
        '     "control": "play"
        ' }
    end if
end sub
sub onSecondVideoMUGSelected()
    print "onSecondVideoMUGSelected()"
    m.gridItemSelected = "secondVideoMUG"
    m.secondVideoSelectedIndex = m.secondVideoMUG.itemSelected
    m.secondVideoSelected = m.secondVideoMUG.content.getChild(m.secondVideoMUG.itemSelected)
    ' m.secondVideoSelected.secondVideoControl = "stop"
    print "m.secondVideoSelected: "m.secondVideoSelected
    print "to parent data assigned"
    pageData = {
        "title": m.secondVideoSelected.secondVideoTitle,
        "control": m.secondVideoSelected.secondVideoControl,
        "url": m.secondVideoSelected.secondVideoUrl,
        "streamFormat": m.secondVideoSelected.secondVideoStreamFormat
    }

    m.secondVideoSelected.secondTimeRenderingSecondVideo = {
        "isSecondTime": true
        "control": "stop"
    }

    m.top.toParentData = {
        "action": "componentCreation",
        "componentName": "fullScreenVideoComponent"
        "pageData": pageData
        
    }
    
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

'         ' moveScreen()        
'     end if

'     m.focusedItem = m.secondVideoMUG.content.getChild(m.focusedItemIndex)
'     m.lastFocusedItemOfSecondVideo = m.focusedItem
'     m.focusedItem.secondTimeRenderingSecondVideo = {
'         "isSecondTime": true
'         "control": "play"
'     }
' end sub

function getFirstVideoDetails() as object
    firstVideoDetails = {
        "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
        "title" : "Test Video",
        "streamformat" : "hls",
        "control": "play",
        "desc": "As an open streaming platform, Roku welcomes publishers and developers to grow their audience with Roku. The Roku OS was purpose-built for streaming and runs across all Roku devices, including streaming players and Roku TVs."
    }
    return firstVideoDetails
end function

function getSecondVideoDetails() as object
    secondVideoDetails = [
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 1",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 2",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 3",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 4",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 5",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 6",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 1",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 2",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 3",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 4",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 5",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        },
        {
            "url": "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8",
            "title" : "Test Video 6",
            "streamformat" : "hls",
            "control": "none",
            "desc": "A streaming video!"
        }
    ]
    return secondVideoDetails
end function


sub renderFirstVideoComponent()

    print "renderFirstVideoComponent()"

    firstVideoDetails = getFirstVideoDetails()
    m.firstVideoParentContent = CreateObject("roSGNode", "ContentNode")
    m.firstVideoChildContent = m.firstVideoParentContent.createChild("firstVideoItemField")
    m.firstVideoChildContent.firstVideoUrl = firstVideoDetails.url
    m.firstVideoChildContent.firstVideoTitle = firstVideoDetails.title
    m.firstVideoChildContent.firstVideoStreamFormat = firstVideoDetails.streamFormat
    m.firstVideoChildContent.firstVideoControl = firstVideoDetails.control
    m.firstVideoChildContent.firstVideoDuration = "2:50"

    m.firstVideoChildContent.firstVideoDesc = firstVideoDetails.desc
    m.firstVideoChildContent.secondTimeRenderingFirstVideo = {
        "isSecondTime": false,
        "control": "play"
    }
    ' m.firstVideoChildContent.setBgi= false
    m.firstVideoMUG.content = m.firstVideoParentContent
    print "Rendered firstVideoComponent"

end sub

sub renderSecondVideoComponent()
    print "renderSecondVideoComponent()"
    secondVideoDetails = getSecondVideoDetails()
    
        
    m.secondVideoParentContent = CreateObject("roSGNode", "ContentNode")
   
    for each item in secondVideoDetails
        m.secondVideoChildContent = m.secondVideoParentContent.createChild("secondVideoItemField")
        m.secondVideoChildContent.secondVideoUrl = item.url
        m.secondVideoChildContent.secondVideoTitle = item.title
        m.secondVideoChildContent.secondVideoStreamFormat = item.streamFormat
        m.secondVideoChildContent.secondVideoDuration = "2:50"
        'm.secondVideoChildContent.secondVideoControl = item.control
    
        m.secondVideoChildContent.secondVideoDesc = item.desc
        m.secondVideoChildContent.secondTimeRenderingSecondVideo = {
            "isSecondTime": false,
            "control": "stop"
        }
    end for
    print "setting content"
    m.secondVideoMUG.content = m.secondVideoParentContent
end sub

sub onSetFocus(event)
    
    print "inside: onSetFocus()"
    ' renderFirstVideoComponent()
    ' renderSecondVideoComponent()
    if event.getData()
        print "if event.getData()"
        m.firstVideoMUG.setFocus(true)
        playFirstVideo()
        print "playFirstVideo(): executed"
    else
        stopFirstVideo()
    end if
    
    print "m.firstVideoMUG.hasFocus(): "m.firstVideoMUG.hasFocus()
    'm.firstVideoChildContent.firstVideoControl = "play"
    'print "m.secondVideoMUG: "m.secondVideoMUG.hasFocus()
end sub

sub stopFirstVideo()
    m.firstVideoChildContent.secondTimeRenderingFirstVideo = {
        "isSecondTime": true
        "control": "stop"
    }
end sub

' sub onPlayFirstVideoSetToTrue()
'     m.firstVideoMUG.setFocus(true)
'     playFirstVideo()
' end sub

sub playFirstVideo()

    m.firstVideoChildContent.secondTimeRenderingFirstVideo = {
        "isSecondTime": true
        "control": "play"
    }
end sub

sub playSecondVideo()
    m.lastFocusedItemOfSecondVideo.secondTimeRenderingSecondVideo = {
        "isSecondTime": true
        "control": "play"
    }
end sub
sub stopSecondVideo()
    m.lastFocusedItemOfSecondVideo.secondTimeRenderingSecondVideo = {
        "isSecondTime": true
        "control": "stop"
    }
end sub


function onKeyEvent(key as string, press as boolean) as boolean
    if press
        if key = "left"
            print "left clicked"
            if m.firstVideoMUG.hasFocus()
                m.top.toParentData = {
                    "action": "moveScreen"
                    "direction": "original",
                    "component": "searchComponent",
                    "spaceToMove": 0
                }
                stopFirstVideo()
                return false
            else if m.secondVideoMUG.hasFocus()
                stopSecondVideo()
                m.previousFocusedColumn = 0
                m.top.toParentData = {
                    "action": "moveScreen"
                    "direction": "original",
                    "component": "searchComponent",
                    "spaceToMove": 0
                }
                m.firstVideoMUG.setFocus(true)
                playFirstVideo()
                return true

            end if
        else if key = "right"
            print "right clicked"
            if m.firstVideoMUG.hasFocus()
                stopFirstVideo()
                m.secondVideoMUG.setFocus(true)
                return true
            end if
            return true
        else if key="back"
            print "back pressed"
            if m.firstVideoMUG.hasFocus()
                print "m.firstVideoMUG.hasFocus()"
                stopFirstVideo()
                return false
            else if m.secondVideoMUG.hasFocus()
                print "m.secondVideoMUG.hasFocus()"
                m.previousFocusedColumn = 0
                stopSecondVideo()
                m.top.toParentData = {
                    "action": "moveScreen"
                    "direction": "original",
                    "component": "searchComponent",
                    "spaceToMove": 0
                }
                return false
            ' else if not m.secondVideoMUG.hasFocus() or not m.firstVideoMUG.hasFocus()
            '     PRINT "BACK FROM SEARCH COMP IS HANDLED"
                
                
            '     m.firstVideoMUG.setFocus(true)
            '     return true
            end if
        end if
    end if
    return false
end function