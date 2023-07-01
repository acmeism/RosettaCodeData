using System;

    class Program
    {
        private static string BlockCommentStrip(string commentStart, string commentEnd, string sampleText)
        {
            while (sampleText.IndexOf(commentStart) > -1 && sampleText.IndexOf(commentEnd, sampleText.IndexOf(commentStart) + commentStart.Length) > -1)
            {
                int start = sampleText.IndexOf(commentStart);
                int end = sampleText.IndexOf(commentEnd, start + commentStart.Length);
                sampleText = sampleText.Remove(
                    start,
                    (end + commentEnd.Length) - start
                    );
            }
            return sampleText;
        }
    }
