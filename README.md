# datasets
A storage place for our datasets
# cloning
To get started, clone this repository to your local computer. Navigate in your terminal to your desired location on your computer, and run this command:
<p><pre>$ git clone https://github.com/lindsaycarbonell/datasets</pre></p>
Now you have a cloned copy of this repo, which is connected to GitHub.
# branching
Whenever you want to update this repository, you must create a new branch and merge that branch with the master branch.
first, create a new branch:
<pre>$ git checkout -b [name_of_your_new_branch]</pre>
Now you can add the files you'd like and make modifications on your local computer. When you're finished, commit and push your changes. 
<pre>$ git add -A</pre>
<pre>$ git commit -m [commit_message]</pre>
<pre>$ git push origin [your_branch_name]</pre>

Now go back to GitHub in your browser and change the dropdown menu for the branch to your branch name.

Click the "New pull request" button and finish merging your pull request until you see your merge message in the master branch.


Once you've finished your merge, you are free to delete your branch.
<p><pre>$ git branch -D [name_of_your_branch]</pre></p>

You can also look at all of your branches with this command:
<p><pre>$ git branch</pre></p>
