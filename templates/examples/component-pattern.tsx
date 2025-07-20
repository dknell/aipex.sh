import React, { useState, useCallback, useMemo } from 'react';

// TypeScript interfaces - always define before usage
interface ComponentProps {
  readonly title: string;
  readonly items: readonly Item[];
  readonly onItemSelect?: (item: Item) => void;
  readonly className?: string;
}

interface Item {
  readonly id: string;
  readonly name: string;
  readonly description?: string;
  readonly isActive: boolean;
}

// Component state interface
interface ComponentState {
  readonly selectedItem: Item | null;
  readonly isLoading: boolean;
  readonly error: string | null;
}

/**
 * Example component following enterprise patterns
 * 
 * @param props - Component properties
 * @returns JSX element
 */
export const ExampleComponent: React.FC<ComponentProps> = ({
  title,
  items,
  onItemSelect,
  className = '',
}) => {
  // State with proper typing
  const [state, setState] = useState<ComponentState>({
    selectedItem: null,
    isLoading: false,
    error: null,
  });

  // Memoized calculations
  const activeItems = useMemo(
    () => items.filter(item => item.isActive),
    [items]
  );

  // Callback handlers with proper typing
  const handleItemClick = useCallback((item: Item) => {
    setState(prev => ({ ...prev, selectedItem: item }));
    onItemSelect?.(item);
  }, [onItemSelect]);

  // Error boundary handling
  if (state.error) {
    return (
      <div className={`error-container ${className}`}>
        <p>Error: {state.error}</p>
      </div>
    );
  }

  return (
    <div className={`component-container ${className}`}>
      <h2>{title}</h2>
      {state.isLoading ? (
        <div>Loading...</div>
      ) : (
        <ul>
          {activeItems.map(item => (
            <li
              key={item.id}
              onClick={() => handleItemClick(item)}
              className={item === state.selectedItem ? 'selected' : ''}
            >
              <h3>{item.name}</h3>
              {item.description && <p>{item.description}</p>}
            </li>
          ))}
        </ul>
      )}
    </div>
  );
};

export default ExampleComponent;