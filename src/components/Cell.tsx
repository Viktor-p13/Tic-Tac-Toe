import type { CellValue } from '../types/game'

interface CellProps {
  value: CellValue
  onClick: () => void
  disabled: boolean
}

export function Cell({ value, onClick, disabled }: CellProps) {
  return (
    <button type="button" className="cell" onClick={onClick} disabled={disabled}>
      {value ?? ''}
    </button>
  )
}
