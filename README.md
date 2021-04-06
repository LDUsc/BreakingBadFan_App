# BreakingBadFan_App
 A trivia app, based on TV series "Breaking Bad", where users can look up details about episodes, characters and save their favourite quotes.
 
This Application was built according to the task, provided by CodeAcademy iOS Course. 
 The goal of the application is to demonstrate good understanding of: 
 - Standard UIKit Framework Elements
 - Creating UI Elements using Xibs and Storyboards
 - Networking 
 - Parsing Data with JSON
 - Delegate Pattern
 - Data Persistence using User Defaults and Keychain
 
This application uses Breaking Bad API: https://breakingbadapi.com

<p align="center">
  <img width="300" src="/HomeScreen.png">
  <img src="/BreakingBadAppDemo.gif" width="300">
</p>

## - Episodes 

List of seasons and episodes.
When episode is selected user is provided with basic details about the episode, as well as list of characters that appeared in the season. If character is selected, user is taken to the character detail view.

<p align="center">
<img src="/EpisodesListScreen.png" width="270" align="center" >
 <img src="/EpisodeDetailsScreen.png" width="270" align="center" >
 </p>
 
 ## - Filtering Episodes

Users can filter episodes by:
 - Seasons
 - From and/or To air dates
 - Character appearances

<p align="center">
<img src="/EpisodesFilterScreen.png" width="270" align="center" >
 <img src="/EpisodesFilterSeasons.png" width="270" align="center" >
 <img src="/EpisodesFilterDatePicker.png" width="270" align="center" >
 </p>
 
 ## - Characters 

List of characters that appeared in the series.
When character is selected user is provided with basic details about the character as well as characters quotes from the series (If quotes for given character exist within the Breaking Bad API).

<p align="center">
<img src="/CharactersListScreen.png" width="270" align="center" >
 <img src="/CharacterDetailsScreen.png" width="270" align="center" >
 </p>
 
  ## - Filtering Characters

Users can filter characters by:
 - Character life status
 - Season features

<p align="center">
<img src="/CharactersFilterScreen.png" width="270" align="center" >
 </p>
 
  ## - Quotes

Users can:
 - See their liked quotes
 - Top three quotes from accross the platform
 - A Random Quote

<p align="center">
<img src="/QuotesScreen.png" width="270" align="center" >
 </p>
