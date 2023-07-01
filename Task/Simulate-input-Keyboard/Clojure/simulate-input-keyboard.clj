(import java.awt.Robot)
(import java.awt.event.KeyEvent)
(defn keytype [str]
  (let [robot (new Robot)]
       (doseq [ch str]
	      (if (Character/isUpperCase ch)
		  (doto robot
			(.keyPress (. KeyEvent VK_SHIFT))
			(.keyPress (int ch))
			(.keyRelease (int ch))
			(.keyRelease (. KeyEvent VK_SHIFT)))
		  (let [upCh (Character/toUpperCase ch)]
		       (doto robot
			     (.keyPress (int upCh))
			     (.keyRelease (int upCh))))))))
