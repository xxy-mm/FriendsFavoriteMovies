# Topics and skills covered
* Reusable detail views for both creating and editing data
* Xcode tools to refactor existing types and generate common code
* Defining sample data and reusing it across SwiftUI previews as a shared instance
* Manually creating Schema, ModelConfiguration, and ModelContainer
* Navigation hierarchies to display structured data using NavigationSplitView, NavigationStack, and NavigationLink
* Modifying data models with @Bindable
* The Form container view
* Displaying modal interfaces using sheets
* Custom view initializers
* Rendering views conditionally using Group
* Relating one model to another using properties
* Making a many-to-one relationship with an optional model type
* Making a one-to-many relationship with an array of model types
* Using a Picker to choose a value from a list of options
* Predicates that use logical expressions to filter data
* Initializing a custom @Query property
* Using a wrapper view to enable dynamic updates of query criteria

## Change log

fix: when adding friend with favorite movie, the sheet popup multiple times.
> conclusion: We need to insert the new friend the same time as the sheet appears in the friend list.If we execute the `modelContext.insert` method in the detail view, the friends array in the list view decorated by @Query will be changed, causing related views being recreated(in this case, the sheet view).
