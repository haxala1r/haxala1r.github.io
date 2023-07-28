(html
  (head
    (style
      (css
	"html" (:background-color "#ddd")
	"body" (:margin "0px" 
		:font-size "18px")
	"#navbar" (:overflow "hidden" :padding-left "20%")
	"#navbar a" (:float "left" :color "#121212" :text-align "center"
		     :text-decoration "none" :padding "10px 14px")
	"#navbar a:hover" (:color "#ff5733" :background-color "#222")
	"#main" (:top-margin "10px" :padding "0px 20%")
	"#main div" (:padding "0px 8px"
		     :color "#444" :background-color "#ddd"
		     :float "left" :border "1px solid black" :box-shadow "0px 4px 24px black")
	"a" (:color "#ff5733" :text-decoration none)
	"h1" (:text-align "center"))))
  (body
    (div :attrs (:id "navbar")
      (a :attrs (href "/")
	(b "home"))
      (a :attrs (:href "https://github.com/haxala1r")
	(b "GitHub")))
    (div :attrs (:id "main")
      (div
	(process-markdown *markdown-file*)))))
