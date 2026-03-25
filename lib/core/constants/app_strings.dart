/// Centralized string constants used throughout the RACIPAY app.
class AppStrings {
  // App
  static const String appName = 'RACIPAY';
  static const String appTagline =
      'Manage your Racitelcom bills, payments, and support in one place.';

  // Authentication
  static const String loginTitle = 'Welcome to RACIPAY';
  static const String loginSubtitle =
      'Sign in to manage your Racitelcom internet account.';
  static const String emailLabel = 'Email address';
  static const String passwordLabel = 'Password';
  static const String loginButton = 'Sign In';
  static const String logoutButton = 'Log Out';
  static const String forgotPassword = 'Forgot Password?';

  // Common buttons
  static const String buttonRetry = 'Try Again';
  static const String buttonSeeAll = 'See All';
  static const String buttonPayNow = 'Pay Now';
  static const String buttonViewDetails = 'View Details';
  static const String buttonViewInvoice = 'View Invoice';
  static const String buttonSubmit = 'Submit';
  static const String buttonSaveChanges = 'Save Changes';
  static const String buttonUpdateStatus = 'Update Status';
  static const String buttonUpload = 'Upload';
  static const String buttonContinue = 'Continue';
  static const String buttonBackToDashboard = 'Back to Dashboard';
  static const String buttonCreateTicket = 'Create Ticket';
  static const String buttonViewAllTickets = 'View All Tickets';

  // Generic states
  static const String loading = 'Loading...';
  static const String emptyTitle = 'Nothing here yet';
  static const String emptySubtitle =
      'There is currently no data to display.';
  static const String errorTitle = 'Something went wrong';
  static const String errorGeneric =
      'We encountered a problem while loading your data. Please try again.';

  // Empty state messages
  static const String emptyInvoicesTitle = 'No invoices yet';
  static const String emptyInvoicesSubtitle =
      'Your invoices will appear here once Racitelcom generates them.';

  static const String emptyPaymentsTitle = 'No payments recorded';
  static const String emptyPaymentsSubtitle =
      'Your payment history will appear here after you make a payment.';

  static const String emptyTicketsTitle = 'No support tickets';
  static const String emptyTicketsSubtitle =
      'Having an issue? Create a ticket and our team will assist you.';

  static const String emptyAnnouncementsTitle = 'No announcements';
  static const String emptyAnnouncementsSubtitle =
      'Racitelcom announcements will appear here.';

  static const String emptyAssignedTicketsTitle = 'No assigned jobs';
  static const String emptyAssignedTicketsSubtitle =
      'You currently have no tickets assigned. Please check back later.';

  static const String emptyCompletedJobsTitle = 'No completed jobs';
  static const String emptyCompletedJobsSubtitle =
      'Completed service tickets will appear here.';

  // Error messages
  static const String errorNetwork =
      'Cannot connect to the network. Please check your internet connection.';
  static const String errorServer =
      'The server is not responding. Please try again later.';
  static const String errorUnknown = 'An unexpected error occurred.';
  static const String errorInvalidCredentials =
      'Invalid email or password. Please check your credentials.';

  // Subscriber screen titles
  static const String subscriberDashboardTitle = 'Subscriber Dashboard';
  static const String currentBillTitle = 'Current Bill';
  static const String invoicesTitle = 'Invoices';
  static const String invoiceDetailTitle = 'Invoice Details';
  static const String paymentTitle = 'Payment';
  static const String paymentProcessingTitle = 'Processing Payment';
  static const String paymentSuccessTitle = 'Payment Successful';
  static const String paymentFailedTitle = 'Payment Failed';
  static const String paymentHistoryTitle = 'Payment History';
  static const String ticketsTitle = 'Support Tickets';
  static const String createTicketTitle = 'Create Support Ticket';
  static const String ticketDetailTitle = 'Ticket Details';
  static const String announcementsTitle = 'Announcements';
  static const String subscriptionDetailTitle = 'Subscription Details';
  static const String profileTitle = 'My Profile';
  static const String notificationsTitle = 'Notifications';
  static const String helpAboutTitle = 'Help & About';

  // Lineman screen titles
  static const String linemanDashboardTitle = 'Lineman Dashboard';
  static const String assignedTicketsTitle = 'Assigned Tickets';
  static const String linemanTicketDetailTitle = 'Job Details';
  static const String updateStatusTitle = 'Update Ticket Status';
  static const String uploadProofTitle = 'Upload Proof Photo';
  static const String completedJobsTitle = 'Completed Jobs';
  static const String linemanProfileTitle = 'My Profile';
  static const String linemanNotificationsTitle = 'Notifications';

  // Payment messages
  static const String paymentSummaryTitle = 'Payment Summary';
  static const String paymentMethodGCash = 'Pay with GCash';
  static const String paymentMethodCard = 'Pay with Card';
  static const String paymentProcessingMessage =
      'Redirecting to PayMongo secure payment page...';
  static const String paymentSuccessMessage =
      'Thank you! Your payment has been successfully processed.';
  static const String paymentFailedMessage =
      'Your payment could not be completed. You were not charged.';

  // Ticket messages
  static const String ticketCreatedMessage =
      'Your support ticket has been submitted. Our team will reach out soon.';
  static const String ticketStatusPending = 'Pending';
  static const String ticketStatusInProgress = 'In Progress';
  static const String ticketStatusResolved = 'Resolved';

  // Subscription details
  static const String subscriptionPlan = 'Plan';
  static const String subscriptionSpeed = 'Speed';
  static const String subscriptionMonthlyFee = 'Monthly Fee';
  static const String subscriptionAccountNumber = 'Account Number';

  // Profile fields
  static const String profileName = 'Full Name';
  static const String profileEmail = 'Email';
  static const String profilePhone = 'Mobile Number';
  static const String profileAddress = 'Service Address';

  // Splash
  static const String splashLoadingMessage =
      'Preparing your RACIPAY experience...';
}

