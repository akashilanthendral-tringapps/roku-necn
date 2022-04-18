sub init()
    print "init of firstVideoComponent..............."
    m.firstVideo = m.top.findNode("firstVideo")
    m.bgi = m.top.findNode("bgi")
    m.videoDurationDesc = m.top.findNode("videoDurationDesc")
    m.firstVideo.observeField("state", "handleState")
    m.firstVideoDescNode = m.top.findNode("firstVideoDesc")
    m.watchNowRectId = m.top.findNode("watchNowRectId")
    m.whiteRect = m.top.findNode("whiteRect")
    m.muteIcon = m.top.findNode("muteIcon")
end sub

sub setContent()
    print "setContent()"
    m.values = m.top.itemContent
    m.firstVideoUrl = m.values.firstVideoUrl
    m.firstVideoTitle = m.values.firstVideoTitle
    m.firstVideoControl = m.values.firstVideoControl
    m.firstVideoStreamFormat = m.values.firstVideoStreamFormat
    m.firstVideoDuration = m.values.firstVideoDuration

    m.secondTimeRenderingFirstVideo = m.values.secondTimeRenderingFirstVideo
    m.firstVideoDesc = m.values.firstVideoDesc
   
    setFirstVideoSize()
    if m.secondTimeRenderingFirstVideo.isSecondTime = false
 
        setWatchNowText(true)
        setWhiteRectVisibility(true)
        setMuteIconVisibility(true)
        setBackgroundImageVisible(false)
        setVideo()
    else

        if m.secondTimeRenderingFirstVideo.control = "stop"
            setWatchNowText(false)
            setWhiteRectVisibility(false)
            setMuteIconVisibility(false)
            setBackgroundImageVisible(true)
            stopVideo()
        else
            setWatchNowText(true)
            setWhiteRectVisibility(true)
            setMuteIconVisibility(true)
            setBackgroundImageVisible(false)
            playVideo()
        end if
    end if
    
end sub

sub setWatchNowText(visibility)
    m.watchNowRectId.visible = visibility
end sub

sub setWhiteRectVisibility(visibility)
    m.whiteRect.visible = visibility
end sub 
sub setMuteIconVisibility(visibility)
    m.muteIcon.visible = visibility
end sub 

sub setBackgroundImageVisible(bool as boolean)
    m.bgi.visible = bool
    m.firstVideo.visible = not bool
end sub

sub stopVideo()
    m.firstVideo.control = "stop"
end sub

sub playVideo()
    m.firstVideo.control = "play"
end sub

function setVideo() as void
    print " setVideo()"
    videoContent = createObject("RoSGNode", "ContentNode")
    videoContent.url = m.firstVideoUrl
    videoContent.title = m.firstVideoTitle
    videoContent.streamformat = m.firstVideoStreamFormat
    m.firstVideoDescNode.text = m.firstVideoDesc
    m.firstVideo.content = videoContent
    m.firstVideo.control = m.firstVideoControl
    m.videoDurationDesc.text = m.firstVideoDuration
    m.firstVideo.setFocus(true)
   
end function


sub handleState()
    print "handleState()"
    print "m.firstVideo.state: "m.firstVideo.state
    if m.firstVideo.state = "finished"
        print "video finished"
        m.firstVideo.control = "play"
    else if m.firstVideo.state = "playing"
        
    end if
end sub

sub setFirstVideoSize()
    print "sub handleincreaseFirstVideoSize()"
        m.firstVideo.width = "1000"
        m.firstVideo.height = "565.2"
        m.firstVideo.translation = "[10,0]"
end sub

function onKeyEvent(key as String, press as boolean) as boolean
    if press
        if key = "back"
            print "BACK FROM FIRST VIDEO COMPONENT IS HANDLED"
            return false
        end if
    end if
    return false
end function
