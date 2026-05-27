interface ScoreBoardProps {
  scores: { X: number; O: number; draws: number }
}

export function ScoreBoard({ scores }: ScoreBoardProps) {
  return (
    <div className="scoreboard" aria-label="Scoreboard">
      <span>X: {scores.X}</span>
      <span>Draws: {scores.draws}</span>
      <span>O: {scores.O}</span>
    </div>
  )
}
