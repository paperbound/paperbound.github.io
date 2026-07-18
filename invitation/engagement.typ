// =====================================================================
//  Engagement invitation  —  Prasanth & Sharon
// =====================================================================

#import "invitation.typ"

#set document(
  title: "Engagement - Prasanth & Sharon",
)

#set page(
  paper: "a5",
  margin: (x: 1cm, y: 1cm),
  background: context {
    invitation.confetti-border()
  },
)

#invitation.invitation(
  "Two are better than one ... — Ecclesiastes 4:9",
  "Sharon Laurance",
  [
    Mr. Laurance & Mrs. Smita \
  ],
  "Muthipeedika, Regency Anantham, Dombivli",
  "Prasanth Shaji",
  [
    Dr. Shaji & Dr. Asha \
  ],
  "Tharasseril, Thevally, Kollam",
  (
    [request the honour of your presence],
    [at the engagement of their daughter],
  ),
  [son of],
  [Our Lady of Dolours Basilica, Thrissur],
  "Saturday",
  "22",
  "August",
  "2026",
  "10:30 A.M.",
  [Reception follows at *Hyatt Regency* \ from 11:00 A.M. to 3:00 P.M.],
  "Sharing the happiness, Daisy and Rohit",
)

