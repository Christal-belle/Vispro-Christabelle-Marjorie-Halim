1. HeaderBar
- Trigger: Readability
- Owns: Tampilan AppBar termasuk judul "Drama Watchlist"
- Reports upward: Tidak ada

2. FilterTabs
- Trigger: Reuse dan readability
- Owns: Tampilan filter menggunakan ChoiceChip (All, Watching, Completed, Plan)
- Reports upward: Nilai filter yang dipilih melalui callback `onChanged`

3. DramaList
- Trigger: Readability
- Owns: Tampilan daftar drama menggunakan ListView serta penanganan kondisi kosong (empty state)
- Reports upward: Tidak ada

4. DramaCard
- Trigger: Readability
- Owns: Tampilan satu item drama (Card dan ListTile)
- Reports upward: Tidak ada

