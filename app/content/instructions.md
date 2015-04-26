### Using the app

This application attempts to predict the next word given a set of initial words.
A text box is provided as input,
and the next word is predicted each time the user types a space (`" "`)
or presess the `Predict!` button.

One prediction is shown in the red button labeled <span class="badge">1</span>,
like 
<div class="col-sm-3">
<button id="showpred1" type="button" class="btn btn-default" style="font-weight: bolder; float:left; background: #FFCCCC;">
<span class="badge" style="float:left;">1</span>
<div>prediction</div></button></div>
</br></br>

and two additional words are provided as suggestions.
You can **click the red prediction button** or the _grey suggestion buttons_
to add the word to the text input and predict the next word.
If you are using Google Chrome as your browser,
pressing the numbers 1-3 also select the relevant prediction or suggestion
(does not work in firefox or explorer).
A blank input will predict the three most common words `and`, `the` and `to`.

The `Clear input` button clears the text box,
and the `Random options` buttons provides three random suggestions to keep the inspiration going (or get it started!).

There are two grey panels showing information about the model.
The **Input text** panel shows the input text as it is interpreted by the app,
and the **Likelihood for all top predictions** shows detailed information about the likelihood for the prediction and the suggestions based on backoff and linear interpolation,
as well as the final likelihood used to select the prediction.

The text box provides some basic autocomplete functionality
based on common English words,
which eases input and helps to get a better prediction.
