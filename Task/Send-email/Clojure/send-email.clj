(require '[postal.core :refer [send-message]])

(send-message {:host "smtp.gmail.com"
               :ssl true
               :user your_username
               :pass your_password}
              {:from "you@yourdomain.com"
               :to ["your_friend@example.com"]
               :cc ["bob@builder.com" "dora@explorer.com"]
               :subject "Yo"
               :body "Testing."})
