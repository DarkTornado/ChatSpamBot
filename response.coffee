###
카카오톡 봇 도배기
© 2021 Dark Tornado, All rights reserved.
라이선스 : APGL 3.0
###

rooms = {}
  
dip2px = (ctx, dips) -> return Math.ceil(dips * ctx.getResources().getDisplayMetrics().density);

onCreate = (sis, ctx) ->
    layout = new android.widget.LinearLayout ctx
    layout.setOrientation 1

    title = new android.widget.Toolbar ctx
    title.setTitle "카카오톡 도배기"
    title.setTitleTextColor android.graphics.Color.WHITE
    title.setBackgroundColor android.graphics.Color.parseColor "#66BB6A"
    title.setElevation dip2px ctx, 3

    roomList = Object.keys rooms
    
    txt0 = new android.widget.TextView ctx
    txt0.setText "채팅방 : "
    txt0.setTextSize 18
    txt0.setTextColor android.graphics.Color.BLACK
    layout.addView txt0
    spin = new android.widget.Spinner ctx
    adapter = new android.widget.ArrayAdapter ctx, android.R.layout.simple_list_item_1, roomList
    spin.setAdapter adapter
    layout.addView spin

    txt1 = new android.widget.TextView ctx
    txt1.setText "\n채팅 내용 : "
    txt1.setTextSize 18
    txt1.setTextColor android.graphics.Color.BLACK
    layout.addView txt1
    txt2 = new android.widget.EditText ctx
    txt2.setHint "전송할 내용 입력..."
    layout.addView txt2

    txt3 = new android.widget.TextView ctx
    txt3.setText "\n횟수 : "
    txt3.setTextSize 18
    txt3.setTextColor android.graphics.Color.BLACK
    layout.addView txt3
    txt4 = new android.widget.EditText ctx
    txt4.setHint "전송할 내용 입력..."
    txt4.setInputType android.text.InputType.TYPE_CLASS_NUMBER
    layout.addView txt4

    send = new android.widget.Button ctx
    send.setText "전송"
    send.setOnClickListener(new android.view.View.OnClickListener(
        onClick = (v) -> 
            id = spin.getSelectedItemId()
            if id < 0
                print "채팅을 전송할 방이 없어요."
                return
            replier = rooms[roomList[id]]
            msg = txt2.getText().toString()
            count = Number txt4.getText()
            if count > 4
                print count + "번은 너무 많소, 4번으로 합시다."
                count = 4
            sendChat msg, replier, count
            print "전송 완료"
    ))
    layout.addView send
    
    help = new android.widget.Button ctx
    help.setText "기능 정보 & 도움말"
    help.setOnClickListener(new android.view.View.OnClickListener(
        onClick = (v) -> showDialog ctx
    ))
    layout.addView help

    alert = new android.widget.TextView ctx
    alert.setText "\n개발자는 이 기능을 사용함으로서 발생하는 모든 일에 대하여 책임을 지지 않아요."
    alert.setTextSize 18
    alert.setTextColor android.graphics.Color.BLACK
    layout.addView alert

    maker = new android.widget.TextView ctx
    maker.setText "\n© 2021 Dark Tornado, All rights reserved.\n"
    maker.setTextSize(12);
    maker.setTextColor android.graphics.Color.BLACK
    maker.setGravity android.view.Gravity.CENTER
    layout.addView maker

    pad = dip2px ctx, 16
    layout.setPadding pad, pad, pad, pad

    scroll = new android.widget.ScrollView ctx
    scroll.addView layout

    layout0 = new android.widget.LinearLayout ctx
    layout0.setOrientation 1
    layout0.addView title
    layout0.addView scroll
    
    ctx.setContentView layout0

sendChat = (msg, replier, count) -> 
    return if blocked
    n = 0
    while n < count
        replier.reply msg
        n++
        Utils.delay 500

blocked = false

response = (room, msg, sender, isGroupChat, replier) ->
    cmd = msg.split " "
    if msg is "/꺼"
        blocked = true
        replier.reply "도배기 강제 비활성화 완료"
    if cmd[0] is "/ev"
        cmd.shift()
        src = cmd.join " "
        replier.reply eval src + ""
    rooms[room] = replier

showDialog = (ctx) -> 
    dialog = new android.app.AlertDialog.Builder ctx
    dialog.setTitle "기능 정보 & 도움말"
    dialog.setMessage "이름 : 카카오톡 봇 도배기\n개발자 : Dark Tornado\n라이선스 : AGPL 3.0\n\n" + 
        "  리로드 이후에 한 번 이상 채팅이 수신된 적이 있는 방으로만 도배를 할 수 있고, 한 번에 최대 4번 까지만 가능해요.\n" + 
        "  개발자는 이 기능을 사용함으로서 발생하는 모든 일에 대하여 책임을 지지 않아요. 도배하다가 계정을 정지당해도 사용한 사람 잘못이에요.\n" +
        "  이 소스를 파는 행위는 금지되어 있고, 소스를 사용하는 행위는 해킹 위험에 노출되는 것에 동의하는 것으로 간주되는거에요."
    dialog.setNegativeButton "닫기" , null
    dialog.show()
