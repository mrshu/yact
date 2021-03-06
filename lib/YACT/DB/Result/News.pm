package YACT::DB::Result::News;

=head1 NAME

YACT::DB::Result::News

=cut

use DBIx::Class::Candy -components => [
    'TimeStamp',                 'InflateColumn::DateTime',
    'InflateColumn::Serializer', 'EncodedColumn'
];

=head1 TABLE: C<news>

=cut

table("news");

=head1 ACCESSORS

=head2 news_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'news_news_id_seq'

=head2 conf_id

  data_type: 'text'
  is_nullable: 0

=head2 datetime

  data_type: 'timestamp'
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_nullable: 0

=head2 published

  data_type: 'boolean'
  default_value: false
  is_nullable: 0

=cut

column "news_id",
    {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "news_news_id_seq",
    };

column "conf_id", { data_type => "text", is_nullable => 0 };

column "datetime", { data_type => "timestamp", is_nullable => 0 };

column "user_id", { data_type => "integer", is_nullable => 0 };

column "published",
    { data_type => "boolean", default_value => \"false", is_nullable => 0 };

=head1 PRIMARY KEY

=over 4

=item * L</news_id>

=back

=cut

primary_key("news_id");

=head1 RELATIONS

=head2 news_items

Type: has_many

Related object: L<YACT::DB::Result::NewsItem>

=cut

has_many(
    "news_items", "YACT::DB::Result::NewsItem",
    { "foreign.news_id" => "self.news_id" },
    { cascade_copy      => 0, cascade_delete => 0 },
);

=head1 FUNCTIONS

=head2 publish

Automatically set the article published attribute to true and updates
the DB.

=cut

sub publish {
    my ($self) = @_;
    $self->published(1);
    return $self->update;
}

=head2 unpublish

Automatically set the article published attribute to false and updates
the DB.

=cut

sub unpublish {
    my ($self) = @_;
    $self->published(0);
    return $self->update;
}

=head2 add_news_item

Adding a new news language item to the DB, requires lang, title and
text

=cut

sub add_news_item {
    my ( $self, $lang, $title, $text ) = @_;
    $self->create_related(
        'news_items',
        {   lang  => $lang,
            title => $title,
            text  => $text,
        }
    );
}

1;
