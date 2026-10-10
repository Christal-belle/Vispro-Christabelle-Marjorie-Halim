import 'package:watchlist/core/models/drama.dart';

final List<Drama> kDramas = [
  Drama(
    title: "Lovely Runner",
    status: "Completed",
    year: 2024,
    episodes: 16,
    watchedEpisodes: 16,
    rating: 10,
    episodeDuration: 70,
    genre: "Romance",
    tropes: ["Time Travel", "Idol & Fan"],
    synopsis:
      "Im Sol is a devoted fan of Ryu Sun-jae, a famous idol who has given her hope and strength to keep going. When Sun-jae tragically dies, Sol gets the chance to travel back in time to when they were still in high school. Determined to change his future and prevent his tragic fate, she tries to make different choices. However, as she changes the past, she discovers that their lives are more deeply connected than she ever imagined.",
    imagePath: "https://1.vikiplatform.com/c/40466c/dbbd0e5018.jpg?x=b",
  ),
  Drama(
    title: "Wonderfools",
    status: "Watching",
    year: 2026,
    episodes: 8,
    watchedEpisodes: 4,
    rating: 8,
    episodeDuration: 55,
    genre: "Fantasy",
    tropes: ["Superpower", "Found Family"],
    synopsis: "Set in 1999, when fears of the end of the world are spreading, a group of ordinary people considered outcasts unexpectedly gain superpowers. Eun Chae-ni and her companions must learn to control their unusual abilities, which often appear at the most inconvenient times. As strange incidents and criminal threats begin to emerge in Haeseong City, they must work together to protect their community, even though they are far from being the perfect heroes.",
    imagePath:
        "https://awsimages.detik.net.id/community/media/visual/2026/04/17/the-wonderfools-1776411449782.jpeg?w=700&q=90",
  ),
  Drama(
    title: "Weak Hero",
    status: "Watching",
    year: 2022,
    episodes: 16,
    watchedEpisodes: 1,
    rating: 10,
    episodeDuration: 35-55,
    genre: "Action",
    tropes: ["Weak to Strong", "High School Drama", ],
    synopsis: "Yeon Si-eun is a quiet, top-performing student who appears physically weak. When he becomes a target of school bullying, he uses his intelligence, analytical skills, and strategic thinking to fight back against his stronger opponents. Along the way, he forms friendships with Ahn Su-ho and Oh Beom-seok. However, school violence, emotional struggles, and conflicts between friends gradually test their loyalty and threaten to destroy their bond.",
    imagePath:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRY2BW2KPTRPzxp6x0q0keEOviKpetaq8U-Q_qHn5JstQ&s=10",
  ),
  Drama(
    title: "Business Proposal",
    status: "Plan",
    year: 2022,
    episodes: 12,
    episodeDuration: 65,
    genre: "Romance",
    tropes: ["CEO Male Lead", "Fake Dating"],
    synopsis: "Shin Ha-ri agrees to attend a blind date in place of her best friend, intending to scare the man away by pretending to be someone completely different. However, her plan backfires when she discovers that her date is Kang Tae-moo, the CEO of the company where she works. Tae-moo proposes an arrangement that forces Ha-ri to continue pretending to be someone else. What begins as a simple deception soon turns into a complicated romantic relationship filled with misunderstandings, jealousy, and hilarious moments.",
    imagePath:
        "https://upload.wikimedia.org/wikipedia/en/1/19/A_Business_Proposal.jpg?utm_source=en.wikipedia.org&utm_campaign=index&utm_content=original",
  ),
];


final List<Drama> kEmptyDramas = <Drama>[];

final String kLongName = ('Extraordinarily ' * 13).substring(0, 200);

final String kLongTrope = ('Trope ' * 35).trim();

final List<Drama> kLongNameDramas = [
  Drama(
    title: kLongName,
    status: "Watching",
    year: 2024,
    episodes: 16,
    watchedEpisodes: 3,
    rating: 8.5,
    episodeDuration: 60,
    genre: kLongName,
    tropes: [kLongTrope],
    synopsis: "Im Sol is a young woman whose life changes after she becomes a devoted fan of Ryu Sun-jae, a famous singer and former athlete. His music and positive influence help her find hope during difficult times. However, her world falls apart when she learns that Sun-jae has tragically died. Unexpectedly, Sol gets the chance to travel back in time to 2008, when Sun-jae is still a high school student. Determined to save him from his tragic future, Sol tries to change the events that will eventually lead to his death. She attempts to protect him while navigating the challenges of her own younger life. As she spends more time with Sun-jae, their relationship develops in ways she never expected. However, changing the past proves more complicated than she imagined, and every decision creates new challenges. Throughout the story, Sol must confront the uncertainty of time travel, hidden secrets, and the consequences of changing destiny. Meanwhile, Sun-jae's feelings for Sol gradually become an important part of their intertwined lives. Their relationship faces numerous obstacles, making their journey both romantic and heartbreaking. Lovely Runner explores the power of love, sacrifice, and determination. It shows how far someone might go to protect the person who gives their life meaning."
  ),
  ...kDramas,
];

final List<Drama> kBigDramas = List<Drama>.generate(500, (i) {
  const statuses = ['Watching', 'Completed', 'Plan'];
  return Drama(
    title: 'Drama #${i + 1}',
    status: statuses[i % statuses.length],
    year: 2000 + i % 25,
    episodes: 16,
    watchedEpisodes: i % 17,
    rating: 7 + (i % 30) / 10,
    episodeDuration: 60,
    genre: 'Romance',
    tropes: [i.isEven ? 'CEO Male Lead' : 'Found Family'], 
    synopsis: ''
  );
});