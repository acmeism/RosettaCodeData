on sendmail(msg_to, msg_cc, msg_subject, msg_text)
	tell application "Mail"
		set msg to make new outgoing message with properties {subject:msg_subject, content:msg_text, visible:true}
		tell msg
			make new to recipient with properties {address:msg_to}
			make new cc recipient with properties {address:msg_cc}
			send
		end tell
	end tell
end sendmail
