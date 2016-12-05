when ScrapeButton.Click do
	set ScrapeWeb.Url to SourceTextBox.Text
	call ScrapeWeb.Get

when ScrapeWeb.GotText url,responseCode,responseType,responseContent do
	initialize local Left to split at first text (text: get responseContent, at: PreTextBox.Text)
	initialize local Right to "" in
		set Right to select list item (list: get Left, index: 2)
		set ResultLabel.Text to select list item (list: split at first (text:get Right, at: PostTextBox.Text), index: 1)
