interface RestartButtonProps {
  onRestartRound: () => void
  onResetScores: () => void
}

export function RestartButton({ onRestartRound, onResetScores }: RestartButtonProps) {
  return (
    <div className="actions">
      <button type="button" onClick={onRestartRound}>New round</button>
      <button type="button" className="secondary" onClick={onResetScores}>Reset scores</button>
    </div>
  )
}
